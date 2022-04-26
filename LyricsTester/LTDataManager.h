//
//  Utils.h
//  LyricsTester
//
//  Created by Brandon Yao on 4/21/22.
//

#import <Foundation/Foundation.h>

@interface LTDataManager : NSObject
+ (NSData *)dataForURL:(NSURL *)URL headers:(NSDictionary *)headers;
+ (NSArray *)infoForSearchTerm:(NSString *)name;
+ (NSArray *)lyricsForSong:(NSString *)song artist:(NSString *)artist;
@end
