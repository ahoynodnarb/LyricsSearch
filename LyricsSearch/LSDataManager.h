//
//  LSDataManager.h
//  LyricsSearch
//
//  Created by Brandon Yao on 4/21/22.
//

#import <Foundation/Foundation.h>

@interface LSDataManager : NSObject
+ (void)infoForSearchTerm:(NSString *)searchTerm page:(NSInteger)page pageSize:(NSInteger)pageSize completion:(void (^)(NSArray *info))completion;
+ (void)infoForSearchTerm:(NSString *)searchTerm page:(NSInteger)page completion:(void (^)(NSArray *info))completion;
+ (void)infoForSearchTerm:(NSString *)name completion:(void (^)(NSArray *info))completion;
+ (void)lyricsForSong:(NSString *)song artist:(NSString *)artist completion:(void (^)(NSArray *info))completion;
@end
