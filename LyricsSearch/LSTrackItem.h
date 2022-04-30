//
//  LSQueueItem.h
//  LyricsSearch
//
//  Created by Brandon Yao on 4/29/22.
//

#import <UIKit/UIKit.h>

@interface LSTrackItem : NSObject <NSCopying>
@property (nonatomic, strong) NSArray *lyrics;
@property (nonatomic, strong) UIImage *artImage;
@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) NSString *artistName;
- (instancetype)initWithLyrics:(NSArray *)lyrics artImage:(UIImage *)artImage songName:(NSString *)songName artistName:(NSString *)artistName;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
