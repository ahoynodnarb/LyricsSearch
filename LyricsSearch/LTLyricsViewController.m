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

- (void)setLyrics:(NSArray *)lyrics {
    _lyrics = lyrics;
    self.tableViewController.lyricsArray = lyrics;
    [self.tableViewController.tableView reloadData];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = backgroundImage;
}

- (void)setSong:(NSString *)song {
    _song = song;
    self.songLabel.text = song;
}

- (void)setArtist:(NSString *)artist {
    _artist = artist;
    self.artistLabel.text = artist;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewController = [[LTLyricsTableViewController alloc] initWithLyrics:self.lyrics];
    self.backgroundImageView = [[UIImageView alloc] initWithImage:self.backgroundImage];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurEffectView.frame = self.view.bounds;
    [self.backgroundImageView insertSubview:blurEffectView atIndex:0];
    [self.view addSubview:self.backgroundImageView];
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = UIColor.clearColor;
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.containerView];
    self.songLabel = [[MarqueeLabel alloc] init];
    self.songLabel.marqueeType = MLLeftRight;
    self.songLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightHeavy];
    self.songLabel.textColor = UIColor.whiteColor;
    self.songLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.songLabel.text = self.song;
    [self.view addSubview:self.songLabel];
    self.artistLabel = [[MarqueeLabel alloc] init];
    self.artistLabel.marqueeType = MLLeftRight;
    self.artistLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightHeavy];
    self.artistLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.artistLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.artistLabel.text = self.artist;
    [self.view addSubview:self.artistLabel];
    [NSLayoutConstraint activateConstraints:@[
        [self.backgroundImageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.backgroundImageView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width],
        [self.backgroundImageView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor],
        [self.containerView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:150],
        [self.containerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.containerView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width-50],
        [self.containerView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor constant:-150],
        [self.songLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:50],
        [self.songLabel.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:45],
        [self.songLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.artistLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:100],
        [self.artistLabel.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:45],
        [self.artistLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
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
