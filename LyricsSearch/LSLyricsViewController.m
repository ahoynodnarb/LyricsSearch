//
//  LSLyricsViewController.m
//  LyricsSearch
//
//  Created by Brandon Yao on 1/9/22.
//

#import "LSLyricsViewController.h"

@interface LSLyricsViewController ()
@property (nonatomic, strong) NSArray *lyrics;
@property (nonatomic, strong) NSString *song;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) MarqueeLabel *songLabel;
@property (nonatomic, strong) MarqueeLabel *artistLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *controlsView;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) LSLyricsTableViewController *tableViewController;
@end

@implementation LSLyricsViewController

- (instancetype)initWithLyrics:(NSArray *)lyrics song:(NSString *)song artist:(NSString *)artist image:(UIImage *)image duration:(NSInteger)duration {
    if(self = [super init]) {
        self.lyrics = lyrics;
        self.song = song;
        self.artist = artist;
        self.backgroundImage = image;
        self.duration = duration;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playNextTrack) name:@"playNextTrack" object:nil];
    }
    return self;
}


- (instancetype)initWithTrackItem:(LSTrackItem *)trackItem {
    NSArray *lyrics = [LSDataManager lyricsForSong:trackItem.songName artist:trackItem.artistName];
    NSString *song = trackItem.songName;
    NSString *artist = trackItem.artistName;
    UIImage *image = trackItem.artImage;
    NSInteger duration = trackItem.duration;
    return [self initWithLyrics:lyrics song:song artist:artist image:image duration:duration];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView {
    [super loadView];
    self.tableViewController = [[LSLyricsTableViewController alloc] initWithLyrics:self.lyrics trackDuration:self.duration];
    self.backgroundImageView = [[UIImageView alloc] initWithImage:self.backgroundImage];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundImageView addSubview:blurEffectView];
    [self.view addSubview:self.backgroundImageView];
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.containerView];
    self.songLabel = [[MarqueeLabel alloc] init];
    self.songLabel.marqueeType = MLLeftRight;
    self.songLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightHeavy];
    self.songLabel.textColor = [UIColor whiteColor];
    self.songLabel.text = self.song;
    self.songLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.songLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.songLabel];
    self.artistLabel = [[MarqueeLabel alloc] init];
    self.artistLabel.marqueeType = MLLeftRight;
    self.artistLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightHeavy];
    self.artistLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.artistLabel.text = self.artist;
    self.artistLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.artistLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.artistLabel];
    self.controlsView = [[UIView alloc] init];
    self.controlsView.backgroundColor = [UIColor clearColor];
    self.controlsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.controlsView];
    self.skipButton = [[UIButton alloc] init];
    [self.skipButton addTarget:self action:@selector(playNextTrack) forControlEvents:UIControlEventTouchUpInside];
    [self.skipButton setImage:[UIImage imageNamed:@"SkipIcon"] forState:UIControlStateNormal];
    self.skipButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.controlsView addSubview:self.skipButton];
    self.previousButton = [[UIButton alloc] init];
    [self.previousButton addTarget:self action:@selector(playPreviousTrack) forControlEvents:UIControlEventTouchUpInside];
    [self.previousButton setImage:[UIImage imageNamed:@"PreviousIcon"] forState:UIControlStateNormal];
    self.previousButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.controlsView addSubview:self.previousButton];
    self.pauseButton = [[UIButton alloc] init];
    [self.pauseButton addTarget:self action:@selector(pauseButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.pauseButton setImage:[UIImage imageNamed:@"PauseIcon"] forState:UIControlStateNormal];
    self.pauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.controlsView addSubview:self.pauseButton];
    [self displayContentController:self.tableViewController];
    [NSLayoutConstraint activateConstraints:@[
        [self.backgroundImageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.backgroundImageView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.backgroundImageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.backgroundImageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [blurEffectView.topAnchor constraintEqualToAnchor:self.backgroundImageView.topAnchor],
        [blurEffectView.bottomAnchor constraintEqualToAnchor:self.backgroundImageView.bottomAnchor],
        [blurEffectView.leadingAnchor constraintEqualToAnchor:self.backgroundImageView.leadingAnchor],
        [blurEffectView.trailingAnchor constraintEqualToAnchor:self.backgroundImageView.trailingAnchor],
        [self.containerView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:150],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-100],
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:25],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-25],
        [self.songLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:50],
        [self.songLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:self.tableViewController.tableView.contentInset.left + 25],
        [self.songLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-25],
        [self.artistLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:100],
        [self.artistLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:self.tableViewController.tableView.contentInset.left + 25],
        [self.artistLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-25],
        [self.controlsView.topAnchor constraintEqualToAnchor:self.containerView.bottomAnchor],
        [self.controlsView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.controlsView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.controlsView.widthAnchor constraintEqualToConstant:260],
        [self.previousButton.centerYAnchor constraintEqualToAnchor:self.controlsView.centerYAnchor],
        [self.previousButton.leadingAnchor constraintEqualToAnchor:self.controlsView.leadingAnchor],
        [self.previousButton.heightAnchor constraintEqualToConstant:40],
        [self.previousButton.widthAnchor constraintEqualToConstant:40],
        [self.skipButton.centerYAnchor constraintEqualToAnchor:self.controlsView.centerYAnchor],
        [self.skipButton.trailingAnchor constraintEqualToAnchor:self.controlsView.trailingAnchor],
        [self.skipButton.heightAnchor constraintEqualToConstant:40],
        [self.skipButton.widthAnchor constraintEqualToConstant:40],
        [self.pauseButton.centerXAnchor constraintEqualToAnchor:self.controlsView.centerXAnchor],
        [self.pauseButton.centerYAnchor constraintEqualToAnchor:self.controlsView.centerYAnchor],
        [self.pauseButton.heightAnchor constraintEqualToConstant:40],
        [self.pauseButton.widthAnchor constraintEqualToConstant:40],
    ]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[LSTrackQueue sharedQueue] increment];
}

- (void)displayContentController:(UIViewController *)content {
    [self addChildViewController:content];
    [self.containerView addSubview:content.view];
    content.view.frame = self.containerView.bounds;
    [content didMoveToParentViewController:self];
}

- (void)setPlayingTrack:(LSTrackItem *)track {
    if(!track) [self dismissViewControllerAnimated:YES completion:nil];
    self.backgroundImageView.image = track.artImage;
    self.artistLabel.text = track.artistName;
    self.songLabel.text = track.songName;
    [self.tableViewController setPlayingTrack:track];
}

- (void)playNextTrack {
    LSTrackQueue *sharedQueue = [LSTrackQueue sharedQueue];
    if(sharedQueue.index == [sharedQueue size]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [sharedQueue increment];
    LSTrackItem *nextItem = [sharedQueue currentItem];
    [self setPlayingTrack:nextItem];
}

- (void)playPreviousTrack {
    LSTrackQueue *sharedQueue = [LSTrackQueue sharedQueue];
    if(sharedQueue.index == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [sharedQueue decrement];
    LSTrackItem *previousItem = [sharedQueue currentItem];
    [self setPlayingTrack:previousItem];
}

- (void)pauseButtonPressed {
    self.tableViewController.playing = !self.tableViewController.playing;
    if(self.tableViewController.playing) [self.pauseButton setImage:[UIImage imageNamed:@"PauseIcon"] forState:UIControlStateNormal];
    else [self.pauseButton setImage:[UIImage imageNamed:@"PlayIcon"] forState:UIControlStateNormal];
}

@end
