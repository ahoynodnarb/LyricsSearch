//
//  Utils.m
//  LyricsTester
//
//  Created by Brandon Yao on 4/21/22.
//

#import "LTDataManager.h"

@implementation LTDataManager

+ (NSArray *)infoForSearchTerm:(NSString *)searchTerm page:(NSInteger)page pageSize:(NSInteger)pageSize {
    NSString *const userToken = [[[NSProcessInfo processInfo] environment] objectForKey:@"USER_TOKEN"];
    NSString *const baseURL = [@"https://apic-desktop.musixmatch.com/ws/1.1/track.search?s_track_rating=desc&namespace=lyrics_synched&app_id=web-desktop-app-v1.0&usertoken=" stringByAppendingString:userToken];
    NSString *URLString = [NSString stringWithFormat:@"%@&page=%ld&page_size=%ld&q_track=%@/", baseURL, (long)page, (long)pageSize, searchTerm];
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"%@", URLString);
    NSURL *URL = [NSURL URLWithString:URLString];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSInteger statusCode = [dict[@"message"][@"header"][@"status_code"] intValue];
    NSLog(@"status_code: %ld, %@", (long) statusCode, dict[@"message"]);
    if(statusCode == 404) return nil;
    NSArray *allResults = dict[@"message"][@"body"][@"track_list"];
    NSMutableArray *info = [[NSMutableArray alloc] init];
    for(NSDictionary *result in allResults) {
        NSDictionary *trackInfo = result[@"track"];
        NSString *artistName = trackInfo[@"artist_name"];
        NSString *songName = trackInfo[@"track_name"];
        // sometimes the URL uses http and the app shits itself
        NSURLComponents *components = [NSURLComponents componentsWithURL:[NSURL URLWithString:trackInfo[@"album_coverart_100x100"]] resolvingAgainstBaseURL:YES];
        components.scheme = @"https";
        NSURL *artURL = components.URL;
        NSData *artData = [NSData dataWithContentsOfURL:artURL];
        NSDictionary *dict = @{@"artistName":artistName, @"songName":songName, @"artData":artData};
        [info addObject:dict];
    }
    return info;
}

+ (NSArray *)infoForSearchTerm:(NSString *)searchTerm page:(NSInteger)page {
    return [LTDataManager infoForSearchTerm:searchTerm page:page pageSize:12];
}

+ (NSArray *)infoForSearchTerm:(NSString *)searchTerm {
    return [LTDataManager infoForSearchTerm:searchTerm page:1];
}

+ (NSArray *)lyricsForSong:(NSString *)song artist:(NSString *)artist {
    NSString *const token = [[[NSProcessInfo processInfo] environment] objectForKey:@"USER_TOKEN"];
    NSString *const baseURL = [@"https://apic-desktop.musixmatch.com/ws/1.1/matcher.subtitle.get?app_id=web-desktop-app-v1.0&namespace=lyrics_synched&subtitle_format=mxm&usertoken=" stringByAppendingString:token];
    NSString *URLString = [NSString stringWithFormat:@"%@&q_track=%@&q_artist=%@/", baseURL, song, artist];
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSInteger statusCode = [dict[@"message"][@"header"][@"status_code"] intValue];
    if(statusCode == 404) return nil;
    NSLog(@"status_code: %ld %@", (long) statusCode, dict[@"message"]);
    NSString *lyricsJSON = dict[@"message"][@"body"][@"subtitle"][@"subtitle_body"];
    NSData *lyricsData = [lyricsJSON dataUsingEncoding:NSUTF8StringEncoding];
    return lyricsData ? [NSJSONSerialization JSONObjectWithData:lyricsData options:0 error:nil] : nil;
}

@end
