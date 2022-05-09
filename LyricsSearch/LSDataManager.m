//
//  LSDataManager.m
//  LyricsSearch
//
//  Created by Brandon Yao on 4/21/22.
//

#import "LSDataManager.h"

@implementation LSDataManager

+ (NSString *)getUserToken {
    NSInteger index = arc4random_uniform(4);
    NSString *tokenID = [NSString stringWithFormat:@"USER_TOKEN%ld", index];
    NSString *token = [[[NSProcessInfo processInfo] environment] objectForKey:tokenID];
    return token;
}

+ (NSArray *)infoForSearchTerm:(NSString *)searchTerm page:(NSInteger)page pageSize:(NSInteger)pageSize {
    NSString *const userToken = [LSDataManager getUserToken];
    NSString *const baseURL = [@"https://apic-desktop.musixmatch.com/ws/1.1/track.search?s_track_rating=desc&f_has_subtitle=1&namespace=lyrics_synched&app_id=web-desktop-app-v1.0&usertoken=" stringByAppendingString:userToken];
    NSString *URLString = [NSString stringWithFormat:@"%@&page=%ld&page_size=%ld&q=%@/", baseURL, (long)page, (long)pageSize, searchTerm];
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSInteger statusCode = [dict[@"message"][@"header"][@"status_code"] longValue];
    NSLog(@"%ld", (long)statusCode);
    if(statusCode != 200) return nil;
    NSArray *allResults = dict[@"message"][@"body"][@"track_list"];
    NSMutableArray *info = [[NSMutableArray alloc] init];
    for(NSDictionary *result in allResults) {
        NSDictionary *trackInfo = result[@"track"];
        NSString *artistName = trackInfo[@"artist_name"];
        NSString *songName = trackInfo[@"track_name"];
        NSInteger duration = [trackInfo[@"track_length"] longValue];
        // sometimes the URL uses http and the app shits itself
        NSURLComponents *components = [NSURLComponents componentsWithURL:[NSURL URLWithString:trackInfo[@"album_coverart_100x100"]] resolvingAgainstBaseURL:YES];
        components.scheme = @"https";
        NSURL *artURL = components.URL;
        NSData *artData = [NSData dataWithContentsOfURL:artURL];
        NSDictionary *dict = @{@"artistName":artistName, @"songName":songName, @"artData":artData, @"duration": @(duration)};
        [info addObject:dict];
    }
    return info;
}

+ (NSArray *)infoForSearchTerm:(NSString *)searchTerm page:(NSInteger)page {
    return [LSDataManager infoForSearchTerm:searchTerm page:page pageSize:12];
}

+ (NSArray *)infoForSearchTerm:(NSString *)searchTerm {
    return [LSDataManager infoForSearchTerm:searchTerm page:1];
}

+ (NSArray *)lyricsForSong:(NSString *)song artist:(NSString *)artist {
    NSLog(@"%@ %@", song, artist);
    NSString *const userToken = [LSDataManager getUserToken];
    NSString *const baseURL = [@"https://apic-desktop.musixmatch.com/ws/1.1/matcher.subtitle.get?app_id=web-desktop-app-v1.0&f_subtitle_length_max_deviation=1&namespace=lyrics_synched&subtitle_format=mxm&usertoken=" stringByAppendingString:userToken];
    NSString *URLString = [NSString stringWithFormat:@"%@&q_track=%@&q_artist=%@/", baseURL, song, artist];
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSInteger statusCode = [dict[@"message"][@"header"][@"status_code"] longValue];
    NSLog(@"%ld %@", (long)statusCode, URLString);
    if(statusCode != 200) return nil;
    NSString *lyricsJSON = dict[@"message"][@"body"][@"subtitle"][@"subtitle_body"];
    NSData *lyricsData = [lyricsJSON dataUsingEncoding:NSUTF8StringEncoding];
    return lyricsData ? [NSJSONSerialization JSONObjectWithData:lyricsData options:0 error:nil] : nil;
}

@end
