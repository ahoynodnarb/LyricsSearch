//
//  LSLyricsViewController.h
//  LyricsSearch
//
//  Created by Brandon Yao on 4/20/22.
//

@import MarqueeLabel_ObjC;
#import <UIKit/UIKit.h>
#import "LSPlayerModel.h"

@interface LSLyricsViewController : UIViewController
@property (nonatomic, strong) LSPlayerModel *playerModel;
- (instancetype)initWithLyrics:(NSArray *)lyrics song:(NSString *)song artist:(NSString *)artist image:(UIImage *)image duration:(NSInteger)duration playerModel:(LSPlayerModel *)playerModel;
- (void)setPlayingTrack:(LSTrackItem *)track usingCache:(BOOL)usingCache;
- (void)setPlayingTrack:(LSTrackItem *)track;
- (void)setPlaybackState:(BOOL)paused;
- (void)setElapsedTime:(NSInteger)elapsedTime;
- (void)dismissLyrics;
@end
