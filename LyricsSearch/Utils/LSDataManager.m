//
//  LSDataManager.m
//  LyricsSearch
//
//  Created by Brandon Yao on 4/21/22.
//

#import "LSDataManager.h"
#import "Constants.h"

@implementation LSDataManager

+ (NSString *)getUserToken {
    NSString *token = USER_TOKENS[arc4random_uniform(4)];
    return token;
}

+ (void)infoForSearchTerm:(NSString *)searchTerm page:(NSInteger)page pageSize:(NSInteger)pageSize completion:(void (^)(NSArray *info))completion {
    NSString *userToken = [LSDataManager getUserToken];
    NSString *const baseURL = [@"https://apic-desktop.musixmatch.com/ws/1.1/track.search?s_track_rating=desc&f_has_subtitle=1&namespace=lyrics_synched&app_id=web-desktop-app-v1.0&usertoken=" stringByAppendingString:userToken];
    NSString *URLString = [NSString stringWithFormat:@"%@&page=%ld&page_size=%ld&q=%@/", baseURL, (long)page, (long)pageSize, searchTerm];
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:URL completionHandler:^(NSData *data,NSURLResponse *response, NSError *error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSInteger statusCode = [dict[@"message"][@"header"][@"status_code"] longValue];
        if(statusCode != 200) {
            NSLog(@"%@ failed with status code: %ld", NSStringFromSelector(_cmd), (long)statusCode);
            return;
        }
        NSArray *allResults = dict[@"message"][@"body"][@"track_list"];
        NSMutableArray *info = [[NSMutableArray alloc] init];
        for(NSDictionary *result in allResults) {
            NSDictionary *trackInfo = result[@"track"];
            NSString *artistName = trackInfo[@"artist_name"];
            NSString *songName = trackInfo[@"track_name"];
            NSInteger duration = [trackInfo[@"track_length"] longValue] * 1000;
            NSString *URI = [@"spotify:track:" stringByAppendingString:trackInfo[@"track_spotify_id"]];
            // sometimes the URL uses http and the app shits itself
            NSURLComponents *components = [NSURLComponents componentsWithURL:[NSURL URLWithString:trackInfo[@"album_coverart_100x100"]] resolvingAgainstBaseURL:YES];
            components.scheme = @"https";
            NSURL *artURL = components.URL;
            NSData *artData = [NSData dataWithContentsOfURL:artURL];
            NSDictionary *dict = @{@"artistName":artistName, @"songName":songName, @"artData":artData, @"duration": @(duration), @"URI": URI};
            [info addObject:dict];
        }
        completion(info);
    }] resume];
}

+ (void)infoForSearchTerm:(NSString *)searchTerm page:(NSInteger)page completion:(void (^)(NSArray *info))completion {
    [LSDataManager infoForSearchTerm:searchTerm page:page pageSize:12 completion:completion];
}

+ (void)infoForSearchTerm:(NSString *)searchTerm completion:(void (^)(NSArray *info))completion {
    [LSDataManager infoForSearchTerm:searchTerm page:1 completion:completion];
}

+ (void)lyricsForSong:(NSString *)song artist:(NSString *)artist completion:(void (^)(NSArray *info))completion {
    NSString *userToken = [LSDataManager getUserToken];
    NSString *const baseURL = [@"https://apic-desktop.musixmatch.com/ws/1.1/matcher.subtitle.get?app_id=web-desktop-app-v1.0&f_subtitle_length_max_deviation=1&namespace=lyrics_synched&subtitle_format=mxm&usertoken=" stringByAppendingString:userToken];
    NSString *URLString = [NSString stringWithFormat:@"%@&q_track=%@&q_artist=%@/", baseURL, song, artist];
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    config.URLCache = [NSURLCache sharedURLCache];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    [[session dataTaskWithURL:URL completionHandler:^(NSData *data,NSURLResponse *response, NSError *error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSInteger statusCode = [dict[@"message"][@"header"][@"status_code"] longValue];
        if(statusCode != 200) {
            NSLog(@"%@ failed with status code: %ld", NSStringFromSelector(_cmd), (long)statusCode);
            return;
        }
        NSString *lyricsJSON = dict[@"message"][@"body"][@"subtitle"][@"subtitle_body"];
        NSData *lyricsData = [lyricsJSON dataUsingEncoding:NSUTF8StringEncoding];
        completion(lyricsData ? [NSJSONSerialization JSONObjectWithData:lyricsData options:0 error:nil] : nil);
    }] resume];
}

@end
