//
//  LTSearchResultTableViewCell.m
//  LyricsTester
//
//  Created by Brandon Yao on 4/22/22.
//

#import "LSSearchResultTableViewCell.h"

@interface LSSearchResultTableViewCell ()
@property (nonatomic, assign) CGPoint originalTouchLocation;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *queueSlidingView;
@property (nonatomic, strong) UIImageView *artImageView;
@property (nonatomic, strong) UILabel *songLabel;
@property (nonatomic, strong) UILabel *artistLabel;
@end

@implementation LSSearchResultTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.containerView = [[UIView alloc] init];
        self.containerView.backgroundColor = [UIColor blackColor];
        self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.containerView];
        self.artImageView = [[UIImageView alloc] init];
        self.artImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.artImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.containerView addSubview:self.artImageView];
        self.songLabel = [[UILabel alloc] init];
        self.songLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.songLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        self.songLabel.textColor = [UIColor whiteColor];
        [self.containerView addSubview:self.songLabel];
        self.artistLabel = [[UILabel alloc] init];
        self.artistLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.artistLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        self.artistLabel.textColor = [UIColor grayColor];
        [self.containerView addSubview:self.artistLabel];
        [NSLayoutConstraint activateConstraints:@[
            [self.containerView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
            [self.containerView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
            containerViewLeading = [self.containerView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
            [self.containerView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
            [self.artImageView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:10],
            [self.artImageView.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor constant:-10],
            [self.artImageView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:10],
            [self.artImageView.trailingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:60],
            [self.songLabel.topAnchor constraintEqualToAnchor:self.artImageView.topAnchor],
            [self.songLabel.leadingAnchor constraintEqualToAnchor:self.artImageView.trailingAnchor constant:10],
            [self.songLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-10],
            [self.artistLabel.topAnchor constraintEqualToAnchor:self.songLabel.bottomAnchor],
            [self.artistLabel.leadingAnchor constraintEqualToAnchor:self.artImageView.trailingAnchor constant:10],
            [self.artistLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-10],
        ]];
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(animatePan:)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)setArtImage:(UIImage *)artImage {
    _artImage = artImage;
    self.artImageView.image = artImage;
}

- (void)setSong:(NSString *)song {
    _song = song;
    self.songLabel.text = song;
}

- (void)setArtist:(NSString *)artist {
    _artist = artist;
    self.artistLabel.text = artist;
}

- (LSTrackItem *)trackItem {
    return [[LSTrackItem alloc] initWithArtImage:self.artImage songName:self.song artistName:self.artist duration:self.duration];
}

- (void)resetSlidingView {
    [self.queueSlidingView removeFromSuperview];
    self.queueSlidingView = nil;
    self.originalTouchLocation = CGPointZero;
    containerViewLeading.constant = 0;
    [self layoutIfNeeded];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)recognizer {
    CGPoint currentTouchPoint = [recognizer translationInView:self];
    return fabs(currentTouchPoint.x) > fabs(currentTouchPoint.y);
}

- (void)animatePan:(UIPanGestureRecognizer *)recognizer {
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        self.originalTouchLocation = [recognizer locationInView:self];
        self.queueSlidingView = [[UIView alloc] init];
        self.queueSlidingView.backgroundColor = [UIColor yellowColor];
        self.queueSlidingView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.queueSlidingView];
        [self.contentView sendSubviewToBack:self.queueSlidingView];
        UIImageView *queueIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AddToQueueIcon"]];
        queueIconImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.queueSlidingView addSubview:queueIconImageView];
        [NSLayoutConstraint activateConstraints:@[
            [self.queueSlidingView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
            [self.queueSlidingView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
            [self.queueSlidingView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
            [self.queueSlidingView.trailingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
            [queueIconImageView.heightAnchor constraintEqualToConstant:30],
            [queueIconImageView.widthAnchor constraintEqualToAnchor:queueIconImageView.heightAnchor],
            [queueIconImageView.centerXAnchor constraintEqualToAnchor:self.queueSlidingView.centerXAnchor],
            [queueIconImageView.centerYAnchor constraintEqualToAnchor:self.queueSlidingView.centerYAnchor],
        ]];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint currentTouchLocation = [recognizer locationInView:self];
        CGFloat diff = currentTouchLocation.x - self.originalTouchLocation.x;
        if(diff <= 0) return;
        containerViewLeading.constant = diff;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if(!self.queueSlidingView) return;
        [UIView animateWithDuration:0.35f delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:0.4f options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self resetSlidingView];
        } completion:nil];
        [[LSTrackQueue sharedQueue] enqueue:[self trackItem]];
    }
}

@end
