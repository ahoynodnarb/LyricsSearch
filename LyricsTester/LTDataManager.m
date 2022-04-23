//
//  Utils.m
//  LyricsTester
//
//  Created by Brandon Yao on 4/21/22.
//

#import "LTDataManager.h"

@implementation LTDataManager

+ (NSData *)dataForURL:(NSURL *)URL headers:(NSDictionary *)headers {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"GET"];
    for(NSString *header in headers) {
        [request setValue:[headers valueForKey:header] forHTTPHeaderField:header];
    }
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

+ (NSArray *)infoForTrack:(NSString *)name {
    NSString *searchTerm = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *accessToken = [[[NSProcessInfo processInfo] environment] objectForKey:@"ACCESS_TOKEN"];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.genius.com/search?per_page=12&q=%@&access_token=%@", searchTerm, accessToken]];
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

+ (NSArray *)lyricsForSong:(NSString *)song artist:(NSString *)artist {
    NSString *searchTerm = [NSString stringWithFormat:@"%@ %@", song, artist];
    NSString *URLString = [NSString stringWithFormat:@"https://timestamp-lyrics.p.rapidapi.com/extract-lyrics?name=%@", searchTerm];
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSString *host = @"timestamp-lyrics.p.rapidapi.com";
    NSString *key = @"f47ed3409dmsh35cdc754cb3d2c2p1bb437jsnfd4b45952108";
    NSDictionary *headers = @{
        @"X-RapidAPI-Host": host,
        @"X-RapidAPI-Key": key
    };
    NSData *responseData = [LTDataManager dataForURL:URL headers:headers];
    if(responseData) {
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        NSArray *lyrics = [responseDict objectForKey:@"lyrics"];
        // slice the first one because it's empty
        return [lyrics subarrayWithRange:NSMakeRange(1, [lyrics count] - 1)];
    }
    return nil;
}

@end
