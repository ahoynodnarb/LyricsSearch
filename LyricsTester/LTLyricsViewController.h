//
//  LTLyricsViewController.h
//  LyricsTester
//
//  Created by Brandon Yao on 4/20/22.
//

@import MarqueeLabel_ObjC;
#import <UIKit/UIKit.h>
#import "LTLyricsTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTLyricsViewController : UIViewController
@property (nonatomic, strong) NSArray *lyrics;
@property (nonatomic, strong) NSString *song;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) LTLyricsTableViewController *tableViewController;
- (instancetype)initWithLyrics:(NSArray *)lyrics song:(NSString *)song artist:(NSString *)artist image:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
