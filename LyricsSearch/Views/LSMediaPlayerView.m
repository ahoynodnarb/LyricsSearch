//
//  LSMediaPlayerView.m
//  LyricsSearch
//
//  Created by Brandon Yao on 5/11/22.
//

#import "LSMediaPlayerView.h"

@interface LSMediaPlayerView ()
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *artwork;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, strong) MarqueeLabel *artistLabel;
@property (nonatomic, strong) MarqueeLabel *titleLabel;
@property (nonatomic, strong) UIImageView *artworkImageView;
@property (nonatomic, strong) UIProgressView *progressBar;
@property (nonatomic, strong) UIButton *pauseButton;
@end

@implementation LSMediaPlayerView

- (instancetype)initWithPlayerModel:(LSPlayerModel *)playerModel {
    if(self = [super init]) {
        self.playerModel = playerModel;
        [self setupSubviews];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    [NSLayoutConstraint activateConstraints:@[
        [self.contentContainerView.leadingAnchor constraintEqualToAnchor:self.artworkImageView.trailingAnchor constant:10],
        [self.contentContainerView.trailingAnchor constraintEqualToAnchor:self.pauseButton.leadingAnchor],
        [self.contentContainerView.heightAnchor constraintEqualToConstant:40],
        [self.contentContainerView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.artworkImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8],
        [self.artworkImageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:8],
        [self.artworkImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8],
        [self.artworkImageView.widthAnchor constraintEqualToAnchor:self.artworkImageView.heightAnchor],
        [self.progressBar.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.progressBar.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.progressBar.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.progressBar.heightAnchor constraintEqualToConstant:3],
        [self.artistLabel.leadingAnchor constraintEqualToAnchor:self.contentContainerView.leadingAnchor],
        [self.artistLabel.trailingAnchor constraintEqualToAnchor:self.contentContainerView.trailingAnchor],
        [self.artistLabel.bottomAnchor constraintEqualToAnchor:self.contentContainerView.bottomAnchor],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentContainerView.leadingAnchor],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentContainerView.trailingAnchor],
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentContainerView.topAnchor],
        [self.pauseButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10],
        [self.pauseButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.pauseButton.widthAnchor constraintEqualToAnchor:self.pauseButton.heightAnchor],
        [self.pauseButton.heightAnchor constraintEqualToConstant:40],
    ]];
}

- (void)setCurrentItem:(LSTrackItem *)currentItem {
    self.artist = currentItem.artistName;
    self.title = currentItem.songName;
    self.artwork = currentItem.artImage;
    self.duration = currentItem.duration;
    self.progressBar.progress = 0;
    [self updateSubviews];
}

- (void)updateElapsedTime:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    NSInteger elapsedTime = [userInfo[@"elapsedTime"] intValue];
    double progress = (double)elapsedTime / self.duration;
    self.progressBar.progress = progress;
}

- (void)updatePlayerState:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    BOOL paused = [userInfo[@"paused"] boolValue];
    [self updatePauseButton:paused];
}

- (void)dealloc {
    [self stopObserving];
}

- (void)updateSubviews {
    self.artistLabel.text = self.artist;
    self.titleLabel.text = self.title;
    self.artworkImageView.image = self.artwork;
}

- (void)pauseButtonPressed {
    if(!self.playerModel.currentItem) return;
    self.playerModel.paused = !self.playerModel.paused;
}

- (void)setupSubviews {
    self.contentContainerView = [[UIView alloc] init];
    self.contentContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.contentContainerView];
    self.titleLabel = [[MarqueeLabel alloc] init];
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = self.title;
    self.titleLabel.marqueeType = MLLeftRight;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentContainerView addSubview:self.titleLabel];
    self.artistLabel = [[MarqueeLabel alloc] init];
    self.artistLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    self.artistLabel.textColor = [UIColor grayColor];
    self.artistLabel.text = self.artist;
    self.artistLabel.marqueeType = MLLeftRight;
    self.artistLabel.textAlignment = NSTextAlignmentLeft;
    self.artistLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentContainerView addSubview:self.artistLabel];
    self.artworkImageView = [[UIImageView alloc] initWithImage:self.artwork];
    self.artworkImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.artworkImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.artworkImageView.clipsToBounds = YES;
    self.artworkImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.artworkImageView];
    self.pauseButton = [[UIButton alloc] init];
    [self.pauseButton addTarget:self action:@selector(pauseButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.pauseButton setImage:[UIImage imageNamed:@"PauseIcon"] forState:UIControlStateNormal];
    self.pauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.pauseButton];
    self.progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    self.progressBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.progressBar.progressTintColor = [UIColor whiteColor];
    [self addSubview:self.progressBar];
}

- (void)updatePauseButton:(BOOL)paused {
    NSString *imageName = paused ? @"PlayIcon" : @"PauseIcon";
    [self.pauseButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)playbackEnded {
    self.currentItem = nil;
    self.progressBar.progress = 0.0f;
}

- (void)trackChanged {
    self.currentItem = [self.playerModel currentItem];
}

- (void)beginObserving {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayerState:) name:@"stateChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateElapsedTime:) name:@"updateElapsedTime" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectedToSpotify) name:@"spotifyConnected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectedFromSpotify) name:@"spotifyDisconnected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackEnded) name:@"playbackEnded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trackChanged) name:@"trackChanged" object:nil];
}

- (void)stopObserving {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)connectedToSpotify {
    self.progressBar.progressTintColor = [UIColor colorWithRed:30.0f/255.0f green:215.0f/255.0f blue:96.0f/255.0f alpha:1.0f];
}

- (void)disconnectedFromSpotify {
    self.progressBar.progressTintColor = [UIColor whiteColor];
}

@end
