//
//  Utils.m
//  LyricsTester
//
//  Created by Brandon Yao on 4/21/22.
//

#import "LTDataManager.h"

@implementation LTDataManager
+ (NSData *)dataForURL:(NSURL *)URL headers:(NSDictionary *)headers method:(NSString *)method {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    [request setHTTPMethod:method];
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

+ (NSData *)dataForURL:(NSURL *)URL headers:(NSDictionary *)headers {
    return [self dataForURL:URL headers:headers method:@"GET"];
}

+ (NSData *)dataForURL:(NSURL *)URL {
    return [self dataForURL:URL headers:nil method:@"GET"];
}
+ (NSArray *)infoForTrack:(NSString *)name {
    NSString *access_token = @"14fqESqdMGlW4THQXt6HJnQZfk9O_6J9nFsX4OYJiTxaXJJAVGH0o4JCERehO3gg";
    name = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *searchTerm = [NSString stringWithFormat:@"https://api.genius.com/search?per_page=12&q=%@&access_token=%@", name, access_token];
    NSData *data = [LTDataManager dataForURL:[NSURL URLWithString:searchTerm]];
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
@end
