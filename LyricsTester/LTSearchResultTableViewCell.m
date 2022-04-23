//
//  LTSearchResultTableViewCell.m
//  LyricsTester
//
//  Created by Brandon Yao on 4/22/22.
//

#import "LTSearchResultTableViewCell.h"

@implementation LTSearchResultTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.artImageView = [[UIImageView alloc] init];
        self.artImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.artImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.artImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.artImageView];
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        self.authorLabel = [[UILabel alloc] init];
        self.authorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.authorLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        self.authorLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.authorLabel];
        [NSLayoutConstraint activateConstraints:@[
            [self.artImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10],
            [self.artImageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10],
            [self.artImageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
            [self.artImageView.trailingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:60],
            [self.titleLabel.topAnchor constraintEqualToAnchor:self.artImageView.topAnchor],
            [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.artImageView.trailingAnchor constant:10],
            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],
            [self.authorLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor],
            [self.authorLabel.leadingAnchor constraintEqualToAnchor:self.artImageView.trailingAnchor constant:10],
            [self.authorLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10]
        ]];
    }
    return self;
}

@end
