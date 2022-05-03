//
//  LSTrackitem.h
//  LyricsSearch
//
//  Created by Brandon Yao on 4/29/22.
//

#import <UIKit/UIKit.h>

@interface LSTrackItem : NSObject
@property (nonatomic, strong) UIImage *artImage;
@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, assign) NSInteger duration;
- (instancetype)initWithArtImage:(UIImage *)artImage songName:(NSString *)songName artistName:(NSString *)artistName duration:(NSInteger)duration;
@end
