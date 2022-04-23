//
//  Utils.h
//  LyricsTester
//
//  Created by Brandon Yao on 4/21/22.
//

#import <Foundation/Foundation.h>

@interface LTDataManager : NSObject
//+ (NSData *)dataForURL:(NSURL *)URL headers:(NSDictionary *)headers method:(NSString *)method;
//+ (NSData *)dataForURL:(NSURL *)URL headers:(NSDictionary *)headers;
//+ (NSData *)dataForURL:(NSURL *)URL;
+ (NSData *)dataForURL:(NSURL *)URL headers:(NSDictionary *)headers;
+ (NSArray *)infoForTrack:(NSString *)name;
+ (NSArray *)lyricsForSong:(NSString *)song artist:(NSString *)artist;
@end
