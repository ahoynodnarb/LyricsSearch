//
//  LTSearchResultTableViewCell.h
//  LyricsTester
//
//  Created by Brandon Yao on 4/22/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSSearchResultTableViewCell : UITableViewCell
@property (nonatomic, strong) UIButton *optionsButton;
@property (nonatomic, strong) UIImageView *artImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UIImage *artImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@end

NS_ASSUME_NONNULL_END
