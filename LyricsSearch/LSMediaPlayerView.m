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
@property (nonatomic, assign) NSInteger elapsedTime;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, strong) MarqueeLabel *artistLabel;
@property (nonatomic, strong) MarqueeLabel *titleLabel;
@property (nonatomic, strong) UIImageView *artworkImageView;
@property (nonatomic, strong) UIProgressView *progressBar;
@property (nonatomic, strong) UIButton *pauseButton;
@end

@implementation LSMediaPlayerView

- (instancetype)init {
    if(self = [super init]) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithTrackItem:(LSTrackItem *)item {
    if(self = [super init]) {
        self.currentItem = item;
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
    self.elapsedTime = 0;
    [self updateSubviews];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    id item = change[@"new"];
    if([keyPath isEqualToString:@"elapsedTime"]) {
        self.elapsedTime = [item intValue];
        self.progressBar.progress = (double)self.elapsedTime / (self.duration * 1000);
    }
    if([keyPath isEqualToString:@"currentItem"]) {
        NSLog(@"setting current item");
        self.currentItem = [[LSPlayerModel sharedPlayer] currentItem];
    }
}


- (void)dealloc {
    LSPlayerModel *sharedPlayer = [LSPlayerModel sharedPlayer];
    [sharedPlayer removeObserver:self forKeyPath:@"elapsedTime"];
    [sharedPlayer removeObserver:self forKeyPath:@"currentItem"];
}

- (void)updateSubviews {
    self.artistLabel.text = self.artist;
    self.titleLabel.text = self.title;
    self.artworkImageView.image = self.artwork;
}

- (void)pauseButtonPressed {
    LSPlayerModel *sharedPlayer = [LSPlayerModel sharedPlayer];
    if(sharedPlayer.paused) {
        [self.pauseButton setImage:[UIImage imageNamed:@"PauseIcon"] forState:UIControlStateNormal];
        sharedPlayer.paused = NO;
    }
    else {
        [self.pauseButton setImage:[UIImage imageNamed:@"PlayIcon"] forState:UIControlStateNormal];
        sharedPlayer.paused = YES;
    }
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

- (void)beginObserving {
    LSPlayerModel *sharedPlayer = [LSPlayerModel sharedPlayer];
    [sharedPlayer addObserver:self forKeyPath:@"elapsedTime" options:NSKeyValueObservingOptionNew context:nil];
    [sharedPlayer addObserver:self forKeyPath:@"currentItem" options:NSKeyValueObservingOptionNew context:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
