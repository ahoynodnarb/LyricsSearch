//
//  LTSearchResultTableViewCell.h
//  LyricsTester
//
//  Created by Brandon Yao on 4/22/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTSearchResultTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *artImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@end

NS_ASSUME_NONNULL_END
