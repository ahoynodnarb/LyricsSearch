//
//  LSMediaPlayerView.m
//  LyricsSearch
//
//  Created by Brandon Yao on 5/11/22.
//

#import "LSMediaPlayerView.h"

@interface LSMediaPlayerView ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *artwork;
@property (nonatomic, assign) NSInteger elapsedTime;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, strong) UIView *controlsContainerView;
@property (nonatomic, strong) MarqueeLabel *titleLabel;
@property (nonatomic, strong) UIImageView *artworkImageView;
@property (nonatomic, strong) UIProgressView *progressBar;
@property (nonatomic, strong) UIButton *pauseButton;
@end

@implementation LSMediaPlayerView

- (instancetype)init {
    if(self = [super init]) {
        self.title = @"ahwiugjaoiwgnuiahwgiouansguihaiosugnaosjgfouahsgoaushguaonsgoausgbaousgasbgiaosgb";
        NSURL *placeholderImageURL = [NSURL URLWithString:@"https://lh3.googleusercontent.com/2hDpuTi-0AMKvoZJGd-yKWvK4tKdQr_kLIpB_qSeMau2TNGCNidAosMEvrEXFO9G6tmlFlPQplpwiqirgrIPWnCKMvElaYgI-HiVvXc=w600"];
        NSData *placeholderImageData = [NSData dataWithContentsOfURL:placeholderImageURL];
        self.artwork = [UIImage imageWithData:placeholderImageData];
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
        [self.contentContainerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.contentContainerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.contentContainerView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.contentContainerView.bottomAnchor constraintEqualToAnchor:self.progressBar.topAnchor constant:-2],
        [self.artworkImageView.leadingAnchor constraintEqualToAnchor:self.contentContainerView.leadingAnchor],
        [self.artworkImageView.topAnchor constraintEqualToAnchor:self.contentContainerView.topAnchor],
        [self.artworkImageView.bottomAnchor constraintEqualToAnchor:self.contentContainerView.bottomAnchor],
        [self.artworkImageView.widthAnchor constraintEqualToAnchor:self.artworkImageView.heightAnchor],
        [self.progressBar.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.progressBar.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.progressBar.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [self.progressBar.heightAnchor constraintEqualToConstant:5],
        [self.controlsContainerView.leadingAnchor constraintEqualToAnchor:self.artworkImageView.trailingAnchor constant:10],
        [self.controlsContainerView.trailingAnchor constraintEqualToAnchor:self.pauseButton.leadingAnchor constant:-10],
        [self.controlsContainerView.topAnchor constraintEqualToAnchor:self.contentContainerView.topAnchor],
        [self.controlsContainerView.bottomAnchor constraintEqualToAnchor:self.contentContainerView.bottomAnchor],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.controlsContainerView.leadingAnchor],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.controlsContainerView.trailingAnchor],
        [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.controlsContainerView.centerYAnchor],
        [self.pauseButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10],
        [self.pauseButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.pauseButton.widthAnchor constraintEqualToAnchor:self.pauseButton.heightAnchor],
        [self.pauseButton.heightAnchor constraintEqualToConstant:40],
    ]];
}

- (void)setCurrentItem:(LSTrackItem *)currentItem {
    self.title = currentItem.songName;
    self.artwork = currentItem.artImage;
    self.duration = currentItem.duration;
    self.elapsedTime = 0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    id item = change[@"new"];
    if([keyPath isEqualToString:@"elapsedTime"]) {
        self.elapsedTime = [item intValue];
        self.progressBar.progress = self.elapsedTime / self.duration;
    }
    if([keyPath isEqualToString:@"currentItem"]) {
        self.currentItem = [[LSPlayerModel sharedPlayer] currentItem];
    }
}


- (void)dealloc {
    LSPlayerModel *sharedPlayer = [LSPlayerModel sharedPlayer];
    [sharedPlayer removeObserver:self forKeyPath:@"elapsedTime"];
    [sharedPlayer removeObserver:self forKeyPath:@"currentItem"];
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
    self.controlsContainerView = [[UIView alloc] init];
    self.controlsContainerView.backgroundColor = [UIColor redColor];
    self.controlsContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentContainerView addSubview:self.controlsContainerView];
    self.progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    self.progressBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.progressBar.progressTintColor = [UIColor whiteColor];
    [self addSubview:self.progressBar];
    self.titleLabel = [[MarqueeLabel alloc] init];
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = self.title;
    self.titleLabel.marqueeType = MLLeftRight;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.controlsContainerView addSubview:self.titleLabel];
    self.artworkImageView = [[UIImageView alloc] initWithImage:self.artwork];
    self.artworkImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.artworkImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.artworkImageView.clipsToBounds = YES;
    self.artworkImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentContainerView addSubview:self.artworkImageView];
    self.pauseButton = [[UIButton alloc] init];
    [self.pauseButton addTarget:self action:@selector(pauseButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.pauseButton setImage:[UIImage imageNamed:@"PauseIcon"] forState:UIControlStateNormal];
    self.pauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.pauseButton];
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
