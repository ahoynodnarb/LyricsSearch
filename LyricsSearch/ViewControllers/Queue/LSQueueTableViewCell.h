//
//  LSQueueTableViewCell.h
//  LyricsSearch
//
//  Created by Brandon Yao on 5/17/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSQueueTableViewCell : UITableViewCell {
    NSLayoutConstraint *containerLeading;
}
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *song;
@property (nonatomic, strong) UIImage *artwork;
- (void)animatePan:(UIPanGestureRecognizer *)recognizer completion:(void (^)(BOOL success))completion;
@end

NS_ASSUME_NONNULL_END
