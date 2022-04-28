//
//  LTLyricsTableViewCell.m
//  LyricsTester
//
//  Created by Brandon Yao on 4/23/22.
//

#import "LTLyricsTableViewCell.h"

@implementation LTLyricsTableViewCell

+ (UIColor *)selectedCellColor {
    return [UIColor whiteColor];
}

+ (UIColor *)deselectedCellColor {
    return [UIColor colorWithWhite:1.0 alpha:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected) {
        self.textLabel.transform = CGAffineTransformIdentity;
        self.textLabel.textColor = [LTLyricsTableViewCell selectedCellColor];
        return;
    }
    self.textLabel.transform = CGAffineTransformMakeScale(0.8,0.8);
    self.textLabel.textColor = [LTLyricsTableViewCell deselectedCellColor];
}

@end
