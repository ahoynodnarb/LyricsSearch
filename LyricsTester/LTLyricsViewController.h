//
//  LTLyricsViewController.h
//  LyricsTester
//
//  Created by Brandon Yao on 4/20/22.
//

@import MarqueeLabel_ObjC;
#import <UIKit/UIKit.h>
#import "LTTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTLyricsViewController : UIViewController
@property (nonatomic, strong) LTTableViewController *tableViewController;
@property (nonatomic, strong) MarqueeLabel *songLabel;
@property (nonatomic, strong) MarqueeLabel *artistLabel;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIVisualEffectView *blurEffectView;
@end

NS_ASSUME_NONNULL_END
