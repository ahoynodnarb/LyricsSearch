//
//  LSQueueTableViewCell.h
//  LyricsSearch
//
//  Created by Brandon Yao on 5/17/22.
//

#import <UIKit/UIKit.h>

@interface LSQueueTableViewCell : UITableViewCell {
    NSLayoutConstraint *containerLeading;
}
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *song;
@property (nonatomic, strong) UIImage *artwork;
- (void)animatePan:(UIPanGestureRecognizer *)recognizer completion:(void (^)(BOOL success))completion;
@end
