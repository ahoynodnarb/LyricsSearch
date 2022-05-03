//
//  LSLyricsViewController.m
//  LyricsTester
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trackEnded) name:@"trackEnded" object:nil];
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

- (void)viewDidLoad {
    [super viewDidLoad];
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
        [self.controlsView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:25],
        [self.controlsView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-25]
    ]];
}

- (void)displayContentController:(UIViewController *)content {
    [self addChildViewController:content];
    [self.containerView addSubview:content.view];
    content.view.frame = self.containerView.bounds;
    [content didMoveToParentViewController:self];
}

- (void)setPlayingTrack:(LSTrackItem *)track {
    self.backgroundImageView.image = track.artImage;
    self.artistLabel.text = track.artistName;
    self.songLabel.text = track.songName;
    [self.tableViewController setPlayingTrack:track];
}

- (void)playNextTrack {
    LSTrackQueue *sharedQueue = [LSTrackQueue sharedQueue];
    [sharedQueue increment];
    LSTrackItem *nextItem = [sharedQueue currentItem];
    if(!nextItem) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self setPlayingTrack:nextItem];
}

- (void)playPreviousTrack {
    LSTrackQueue *sharedQueue = [LSTrackQueue sharedQueue];
    [sharedQueue decrement];
    LSTrackItem *previousItem = [sharedQueue currentItem];
    if(previousItem == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self setPlayingTrack:previousItem];
}

- (void)trackEnded {
    [self playNextTrack];
}

- (void)skipTrack {
    [self playNextTrack];
}

- (void)previousTrack {
    [self playPreviousTrack];
}

@end
