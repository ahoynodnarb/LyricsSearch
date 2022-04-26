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

//+ (NSData *)albumArtDataForID:(NSInteger)ID {
//    NSString *APIKey = @"a3454edb65483e706c127deaa11df69d";
//    NSString *URLString = [NSString stringWithFormat:@"https://api.musixmatch.com/ws/1.1/track.search?q=%@&page_size=12&page=1&s_track_rating=desc&apikey=%@", searchTerm, APIKey];
//    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSURL *URL = [NSURL URLWithString:URLString];
//    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:URL] options:NSJSONReadingMutableContainers error:nil];
//}

+ (NSArray *)infoForSearchTerm:(NSString *)searchTerm {
    // do this instead of genius perhaps
//    NSString *APIKey = @"a3454edb65483e706c127deaa11df69d";
//    NSString *URLString = [NSString stringWithFormat:@"https://api.musixmatch.com/ws/1.1/track.search?q=%@&page_size=12&page=1&s_track_rating=desc&apikey=%@", searchTerm, APIKey];
//    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSURL *URL = [NSURL URLWithString:URLString];
//    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:URL] options:NSJSONReadingMutableContainers error:nil];
//    NSArray *tracks = response[@"message"][@"body"][@"track_list"];
//    NSMutableArray *info = [[NSMutableArray alloc] init];
//    for(NSDictionary *track in tracks) {
//        NSDictionary *trackInfo = track[@"track"];
//        NSString *songName = track[@"track_name"];
//        NSString *artistName = track[@"artist_name"];
//        NSData *artData = [LTDataManager albumArtDataForID:trackInfo[@"album_id"]];
//        NSDictionary *dict = @{@"songName": songName, @"artistName": artistName, @"artData":artData};
//        [info addObject:dict];
//    }
//    return info;
    NSString *sanitized = [searchTerm stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *accessToken = [[[NSProcessInfo processInfo] environment] objectForKey:@"ACCESS_TOKEN"];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.genius.com/search?per_page=12&q=%@&access_token=%@", sanitized, accessToken]];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *response = [dict objectForKey:@"response"];
    NSMutableArray *info = [[NSMutableArray alloc] init];
    for(NSDictionary *hit in [response objectForKey:@"hits"]) {
        NSDictionary *result = [hit objectForKey:@"result"];
        NSString *artistNames = [result objectForKey:@"artist_names"];
        NSString *songName = [result objectForKey:@"title"];
        NSURL *artURL = [NSURL URLWithString:[result objectForKey:@"song_art_image_thumbnail_url"]];
        NSData *artData = [NSData dataWithContentsOfURL:artURL];
        NSDictionary *dict = @{@"artistName":artistNames, @"songName":songName, @"artData":artData};
        [info addObject:dict];
    }
    return info;
}

+ (NSInteger)commonTrackIDForSong:(NSString *)song artist:(NSString *)artist {
    NSString *const token = [[[NSProcessInfo processInfo] environment] objectForKey:@"API_KEY"];
    NSString *const baseURL = [@"https://api.musixmatch.com/ws/1.1/track.search?page_size=12&page=1&s_track_rating=desc&apikey=" stringByAppendingString:token];
    NSString *URLString = [NSString stringWithFormat:@"%@&q_track=%@&q_artist=%@", baseURL, song, artist];
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"%@", URLString);
    NSURL *URL = [NSURL URLWithString:URLString];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSInteger commonTrackID = [dict[@"message"][@"body"][@"track_list"][0][@"track"][@"commontrack_id"] intValue];
    return commonTrackID;
//    q_track=Better%20Now%20(Acoustic)&q_artist=Etham
}

+ (NSArray *)lyricsForSong:(NSString *)song artist:(NSString *)artist {
    // sorry I stole someone's key
    NSString *const token = [[[NSProcessInfo processInfo] environment] objectForKey:@"USER_TOKEN"];
    NSString *const baseURL = [@"https://apic-desktop.musixmatch.com/ws/1.1/macro.subtitles.get?format=json&user_language=en&namespace=lyrics_synched&f_subtitle_length_max_deviation=1&subtitle_format=mxm&app_id=web-desktop-app-v1.0&usertoken=" stringByAppendingString:token];
    NSInteger commonTrackID = [LTDataManager commonTrackIDForSong:song artist:artist];
    NSString *URLString = [NSString stringWithFormat:@"%@&commontrack_id=%ld", baseURL, (long)commonTrackID];
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"%@", URLString);
    NSURL *URL = [NSURL URLWithString:URLString];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    if(!data) return nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", dict[@"message"][@"body"][@"macro_calls"][@"track.subtitles.get"][@"message"][@"body"]);
    NSString *lyricsJSON = dict[@"message"][@"body"][@"macro_calls"][@"track.subtitles.get"][@"message"][@"body"][@"subtitle_list"][0][@"subtitle"][@"subtitle_body"];
    NSData *lyricsData = [lyricsJSON dataUsingEncoding:NSUTF8StringEncoding];
    return lyricsData ? [NSJSONSerialization JSONObjectWithData:lyricsData options:0 error:nil] : nil;
}

@end
