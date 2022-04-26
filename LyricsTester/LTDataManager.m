//
//  Utils.m
//  LyricsTester
//
//  Created by Brandon Yao on 4/21/22.
//

#import "LTDataManager.h"

@implementation LTDataManager

+ (NSData *)dataForURL:(NSURL *)URL headers:(NSDictionary *)headers {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    NSData *__block responseData = nil;
    BOOL __block fetchComplete = NO;
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200) responseData = data;
        fetchComplete = YES;
    }];
    [dataTask resume];
    while(!fetchComplete) {}
    return responseData;
}

+ (NSArray *)infoForSearchTerm:(NSString *)searchTerm {
    NSString *const userToken = [[[NSProcessInfo processInfo] environment] objectForKey:@"USER_TOKEN"];
    NSString *const baseURL = [@"https://apic-desktop.musixmatch.com/ws/1.1/track.search?&page_size=12&app_id=web-desktop-app-v1.0&usertoken=" stringByAppendingString:userToken];
    NSString *URLString = [NSString stringWithFormat:@"%@&q_track=%@", baseURL, searchTerm];
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *allResults = dict[@"message"][@"body"][@"track_list"];
    NSMutableArray *info = [[NSMutableArray alloc] init];
    for(NSDictionary *result in allResults) {
        NSDictionary *trackInfo = result[@"track"];
        NSString *artistName = trackInfo[@"artist_name"];
        NSString *songName = trackInfo[@"track_name"];
        NSURL *artURL = [NSURL URLWithString:trackInfo[@"album_coverart_100x100"]];
        NSData *artData = [NSData dataWithContentsOfURL:artURL];
        NSDictionary *dict = @{@"artistName":artistName, @"songName":songName, @"artData":artData};
        [info addObject:dict];
    }
    return info;
}

+ (NSInteger)commonTrackIDForSong:(NSString *)song artist:(NSString *)artist {
    // man I hope this works
    NSString *const token = [[[NSProcessInfo processInfo] environment] objectForKey:@"API_KEY"];
    NSString *const baseURL = [@"https://api.musixmatch.com/ws/1.1/track.search?page_size=1&page=1&s_track_rating=desc&apikey=" stringByAppendingString:token];
    NSString *URLString = [NSString stringWithFormat:@"%@&q_track=%@&q_artist=%@", baseURL, song, artist];
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"%@", URLString);
    NSURL *URL = [NSURL URLWithString:URLString];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", dict);
    NSInteger commonTrackID = [dict[@"message"][@"body"][@"track_list"][0][@"track"][@"commontrack_id"] intValue];
    return commonTrackID;
//    q_track=Better%20Now%20(Acoustic)&q_artist=Etham
}

+ (NSArray *)lyricsForSong:(NSString *)song artist:(NSString *)artist {
    // sorry I stole someone's key
    NSString *const token = [[[NSProcessInfo processInfo] environment] objectForKey:@"USER_TOKEN"];
    NSString *const baseURL = [@"https://apic-desktop.musixmatch.com/ws/1.1/macro.subtitles.get?app_id=web-desktop-app-v1.0&usertoken=" stringByAppendingString:token];
    NSString *URLString = [NSString stringWithFormat:@"%@&q_track=%@&q_artist=%@", baseURL, song, artist];
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", dict[@"message"][@"body"][@"macro_calls"][@"track.subtitles.get"][@"message"][@"body"]);
    NSString *lyricsJSON = dict[@"message"][@"body"][@"macro_calls"][@"track.subtitles.get"][@"message"][@"body"][@"subtitle_list"][0][@"subtitle"][@"subtitle_body"];
    NSData *lyricsData = [lyricsJSON dataUsingEncoding:NSUTF8StringEncoding];
    return lyricsData ? [NSJSONSerialization JSONObjectWithData:lyricsData options:0 error:nil] : nil;
}

@end
