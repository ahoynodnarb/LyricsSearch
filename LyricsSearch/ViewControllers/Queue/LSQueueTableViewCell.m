//
//  LSQueueTableViewCell.m
//  LyricsSearch
//
//  Created by Brandon Yao on 5/17/22.
//

#import "LSQueueTableViewCell.h"

@interface LSQueueTableViewCell ()
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
    self.artistLabel = [[UILabel alloc] init];
    self.artistLabel.textColor = [UIColor whiteColor];
    self.artistLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    self.artistLabel.textColor = [UIColor grayColor];
    self.artistLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.artistLabel];
    self.songLabel = [[UILabel alloc] init];
    self.songLabel.textColor = [UIColor whiteColor];
    self.songLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    self.songLabel.textColor = [UIColor whiteColor];
    self.songLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.songLabel];
    self.artworkImageView = [[UIImageView alloc] init];
    self.artworkImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.artworkImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.artworkImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.artworkImageView];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.artworkImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10],
        [self.artworkImageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10],
        [self.artworkImageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
        [self.artworkImageView.trailingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:60],
        [self.songLabel.topAnchor constraintEqualToAnchor:self.artworkImageView.topAnchor],
        [self.songLabel.leadingAnchor constraintEqualToAnchor:self.artworkImageView.trailingAnchor constant:10],
        [self.songLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],
        [self.artistLabel.topAnchor constraintEqualToAnchor:self.songLabel.bottomAnchor],
        [self.artistLabel.leadingAnchor constraintEqualToAnchor:self.artworkImageView.trailingAnchor constant:10],
        [self.artistLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],
    ]];
}

@end
