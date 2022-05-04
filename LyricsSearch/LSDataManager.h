//
//  LSDataManager.h
//  LyricsSearch
//
//  Created by Brandon Yao on 4/21/22.
//

#import <Foundation/Foundation.h>

@interface LSDataManager : NSObject
+ (NSArray *)infoForSearchTerm:(NSString *)searchTerm page:(NSInteger)page pageSize:(NSInteger)pageSize;
+ (NSArray *)infoForSearchTerm:(NSString *)searchTerm page:(NSInteger)page;
+ (NSArray *)infoForSearchTerm:(NSString *)name;
+ (NSArray *)lyricsForSong:(NSString *)song artist:(NSString *)artist;
@end
