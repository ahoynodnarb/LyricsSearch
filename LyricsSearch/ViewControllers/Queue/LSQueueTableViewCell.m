//
//  LSQueueTableViewCell.m
//  LyricsSearch
//
//  Created by Brandon Yao on 5/17/22.
//

#import "LSQueueTableViewCell.h"

@interface LSQueueTableViewCell ()
@property (nonatomic, assign) CGPoint originalTouchLocation;
@property (nonatomic, strong) UIView *slidingView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *artistLabel;
@property (nonatomic, strong) UILabel *songLabel;
@property (nonatomic, strong) UIImageView *artworkImageView;
@end

@implementation LSQueueTableViewCell

- (void)setArtist:(NSString *)artist {
    _artist = artist;
    self.artistLabel.text = artist;
}

- (void)setSong:(NSString *)song {
    _song = song;
    self.songLabel.text = song;
}

- (void)setArtwork:(UIImage *)artwork {
    _artwork = artwork;
    self.artworkImageView.image = artwork;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.containerView];
    self.artistLabel = [[UILabel alloc] init];
    self.artistLabel.textColor = [UIColor whiteColor];
    self.artistLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    self.artistLabel.textColor = [UIColor grayColor];
    self.artistLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.artistLabel];
    self.songLabel = [[UILabel alloc] init];
    self.songLabel.textColor = [UIColor whiteColor];
    self.songLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    self.songLabel.textColor = [UIColor whiteColor];
    self.songLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.songLabel];
    self.artworkImageView = [[UIImageView alloc] init];
    self.artworkImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.artworkImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.artworkImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.artworkImageView];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        containerLeading = [self.containerView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.artworkImageView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:10],
        [self.artworkImageView.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor constant:-10],
        [self.artworkImageView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:10],
        [self.artworkImageView.trailingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:60],
        [self.songLabel.topAnchor constraintEqualToAnchor:self.artworkImageView.topAnchor],
        [self.songLabel.leadingAnchor constraintEqualToAnchor:self.artworkImageView.trailingAnchor constant:10],
        [self.songLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-10],
        [self.artistLabel.topAnchor constraintEqualToAnchor:self.songLabel.bottomAnchor],
        [self.artistLabel.leadingAnchor constraintEqualToAnchor:self.artworkImageView.trailingAnchor constant:10],
        [self.artistLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-10],
    ]];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)recognizer {
    if(![recognizer isKindOfClass:[UIPanGestureRecognizer class]]) return NO;
    CGPoint currentTouchPoint = [recognizer translationInView:self];
    return fabs(currentTouchPoint.x) > fabs(currentTouchPoint.y);
}

- (void)resetSlidingView {
    slidingTrailing = nil;
    containerLeading.constant = 0;
    [self.slidingView removeFromSuperview];
    self.slidingView = nil;
    [self layoutIfNeeded];
}

- (void)animatePan:(UIPanGestureRecognizer *)recognizer completion:(void (^)(BOOL completed))completion {
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        self.originalTouchLocation = [recognizer locationInView:self];
        self.slidingView = [[UIView alloc] init];
        self.slidingView.backgroundColor = [UIColor redColor];
        self.slidingView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.slidingView];
        [self bringSubviewToFront:self.slidingView];
        UIImageView *slidingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AddToQueueIcon"]];
        slidingImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.slidingView addSubview:slidingImageView];
        [NSLayoutConstraint activateConstraints:@[
            [self.slidingView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
            [self.slidingView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
            [self.slidingView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
            slidingTrailing = [self.slidingView.trailingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
            [slidingImageView.heightAnchor constraintEqualToConstant:30],
            [slidingImageView.widthAnchor constraintEqualToAnchor:slidingImageView.heightAnchor],
            [slidingImageView.centerXAnchor constraintEqualToAnchor:self.slidingView.centerXAnchor],
            [slidingImageView.centerYAnchor constraintEqualToAnchor:self.slidingView.centerYAnchor],
        ]];
        completion(NO);
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint currentTouchLocation = [recognizer locationInView:self];
        CGFloat diff = currentTouchLocation.x - self.originalTouchLocation.x;
        if(diff <= 0) return;
        containerLeading.constant = diff;
        completion(NO);
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if(!self.slidingView) return;
        slidingTrailing.active = NO;
        slidingTrailing = [self.slidingView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
        slidingTrailing.active = YES;
        self.originalTouchLocation = CGPointZero;
        [UIView animateWithDuration:0.25f delay:0.2f options:UIViewAnimationOptionCurveLinear animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            completion(YES);
            [self resetSlidingView];
        }];
    }
}

@end
