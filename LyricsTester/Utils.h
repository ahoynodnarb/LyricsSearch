//
//  Utils.h
//  LyricsTester
//
//  Created by Brandon Yao on 4/21/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject
+ (NSData *)dataForURL:(NSURL *)URL headers:(NSDictionary *)headers;
+ (NSData *)dataForURL:(NSURL *)URL;
@end

NS_ASSUME_NONNULL_END
