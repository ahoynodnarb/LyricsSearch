//
//  LTLyricsViewController.h
//  LyricsTester
//
//  Created by Brandon Yao on 4/20/22.
//

@import MarqueeLabel_ObjC;
#import <UIKit/UIKit.h>
#import "LSTrackItem.h"
#import "LSLyricsTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSLyricsViewController : UIViewController
@property (nonatomic, strong) NSArray *lyrics;
@property (nonatomic, strong) NSString *song;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) MarqueeLabel *songLabel;
@property (nonatomic, strong) MarqueeLabel *artistLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *controlsView;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) LSLyricsTableViewController *tableViewController;
- (instancetype)initWithLyrics:(NSArray *)lyrics song:(NSString *)song artist:(NSString *)artist image:(UIImage *)image;
- (instancetype)initWithTrackItem:(LSTrackItem *)trackItem;
@end

NS_ASSUME_NONNULL_END
