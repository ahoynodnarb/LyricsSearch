//
//  ViewController.m
//  LyricsTester
//
//  Created by Brandon Yao on 1/9/22.
//

#import "LTLyricsViewController.h"
#import "LTDataManager.h"

@interface LTLyricsViewController ()

@end

@implementation LTLyricsViewController

- (instancetype)initWithLyrics:(NSArray *)lyrics song:(NSString *)song artist:(NSString *)artist image:(UIImage *)image {
    if(self = [super init]) {
        self.lyrics = lyrics;
        self.song = song;
        self.artist = artist;
        self.backgroundImage = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewController = [[LTLyricsTableViewController alloc] initWithLyrics:self.lyrics];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:self.backgroundImage];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurEffectView.frame = self.view.bounds;
    [backgroundImageView insertSubview:blurEffectView atIndex:0];
    [self.view addSubview:backgroundImageView];
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = UIColor.clearColor;
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.containerView];
    MarqueeLabel *songLabel = [[MarqueeLabel alloc] init];
    songLabel.marqueeType = MLLeftRight;
    songLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightHeavy];
    songLabel.textColor = UIColor.whiteColor;
    songLabel.translatesAutoresizingMaskIntoConstraints = NO;
    songLabel.text = self.song;
    [self.view addSubview:songLabel];
    MarqueeLabel *artistLabel = [[MarqueeLabel alloc] init];
    artistLabel.marqueeType = MLLeftRight;
    artistLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightHeavy];
    artistLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    artistLabel.translatesAutoresizingMaskIntoConstraints = NO;
    artistLabel.text = self.artist;
    [self.view addSubview:artistLabel];
    [NSLayoutConstraint activateConstraints:@[
        [backgroundImageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [backgroundImageView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width],
        [backgroundImageView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor],
        [self.containerView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:150],
        [self.containerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.containerView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width-50],
        [self.containerView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor constant:-150],
        [songLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:50],
        [songLabel.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:45],
        [songLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [artistLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:100],
        [artistLabel.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:45],
        [artistLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
    [self displayContentController:self.tableViewController];
}

- (void)displayContentController:(UIViewController *)content {
    [self addChildViewController:content];
    [self.containerView addSubview:content.view];
    content.view.frame = self.containerView.bounds;
    [content didMoveToParentViewController:self];
}

@end
