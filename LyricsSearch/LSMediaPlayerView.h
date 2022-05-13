//
//  LSMediaPlayerView.h
//  LyricsSearch
//
//  Created by Brandon Yao on 5/11/22.
//

@import MarqueeLabel_ObjC;
#import <UIKit/UIKit.h>
#import "LSTrackItem.h"
#import "LSPlayerModel.h"

@interface LSMediaPlayerView : UIView
@property (nonatomic, strong) LSTrackItem *currentItem;
@property (nonatomic, strong) LSPlayerModel *playerModel;
- (instancetype)initWithPlayerModel:(LSPlayerModel *)playerModel;
- (void)beginObserving;
- (void)stopObserving;
@end
