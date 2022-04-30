//
//  ViewController.m
//  LyricsTester
//
//  Created by Brandon Yao on 1/9/22.
//

#import "LSLyricsViewController.h"
#import "LSDataManager.h"
#import "LSTrackQueue.h"

@interface LSLyricsViewController ()

@end

@implementation LSLyricsViewController

- (instancetype)initWithLyrics:(NSArray *)lyrics song:(NSString *)song artist:(NSString *)artist image:(UIImage *)image {
    if(self = [super init]) {
        self.lyrics = lyrics;
        self.song = song;
        self.artist = artist;
        self.backgroundImage = image;
    }
    return self;
}

- (instancetype)initWithTrackItem:(LSTrackItem *)trackItem {
    NSArray *lyrics = trackItem.lyrics;
    NSString *song = trackItem.songName;
    NSString *artist = trackItem.artistName;
    UIImage *image = trackItem.artImage;
    return [self initWithLyrics:lyrics song:song artist:artist image:image];
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
    self.tableViewController = [[LSLyricsTableViewController alloc] initWithLyrics:self.lyrics];
    self.backgroundImageView = [[UIImageView alloc] initWithImage:self.backgroundImage];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurEffectView.frame = self.view.bounds;
    [self.backgroundImageView insertSubview:blurEffectView atIndex:0];
    [self.view addSubview:self.backgroundImageView];
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.containerView];
    self.songLabel = [[MarqueeLabel alloc] init];
    self.songLabel.marqueeType = MLLeftRight;
    self.songLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightHeavy];
    self.songLabel.textColor = [UIColor whiteColor];
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
    self.controlsView = [[UIView alloc] init];
    self.controlsView.backgroundColor = [UIColor clearColor];
    self.controlsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.controlsView];
    [NSLayoutConstraint activateConstraints:@[
        [self.backgroundImageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.backgroundImageView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width],
        [self.backgroundImageView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor],
        [self.containerView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:150],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-100],
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:25],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-25],
        [self.songLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:50],
        [self.songLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:45],
        [self.songLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-45],
        [self.artistLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:100],
        [self.artistLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:45],
        [self.artistLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-45],
        [self.controlsView.topAnchor constraintEqualToAnchor:self.containerView.bottomAnchor],
        [self.controlsView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.controlsView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:25],
        [self.controlsView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-25]
    ]];
    [self displayContentController:self.tableViewController];
}

- (void)displayContentController:(UIViewController *)content {
    [self addChildViewController:content];
    [self.containerView addSubview:content.view];
    content.view.frame = self.containerView.bounds;
    [content didMoveToParentViewController:self];
}

- (void)setPlayingTrack:(LSTrackItem *)track {
    self.lyrics = track.lyrics;
    self.backgroundImage = track.artImage;
    self.artist = track.artistName;
    self.song = track.songName;
}

- (void)togglePaused:(BOOL)paused {
    
}

- (void)skipTrack {
    LSTrackQueue *sharedQueue = [LSTrackQueue sharedQueue];
    [sharedQueue decrement];
    LSTrackItem *previousItem = [sharedQueue currentItem];
    if(previousItem == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self setPlayingTrack:previousItem];
}

- (void)previousTrack {
    LSTrackQueue *sharedQueue = [LSTrackQueue sharedQueue];
    [sharedQueue increment];
    LSTrackItem *nextItem = [sharedQueue currentItem];
    if(nextItem == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self setPlayingTrack:nextItem];
}

@end
