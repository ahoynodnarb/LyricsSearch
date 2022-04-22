//
//  Utils.m
//  LyricsTester
//
//  Created by Brandon Yao on 4/21/22.
//

#import "Utils.h"

@implementation Utils
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
@end
