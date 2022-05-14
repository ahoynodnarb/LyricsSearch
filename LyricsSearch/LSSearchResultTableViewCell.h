//
//  LSSearchResultTableViewCell.h
//  LyricsSearch
//
//  Created by Brandon Yao on 4/22/22.
//

#import <UIKit/UIKit.h>
#import "LSDataManager.h"
#import "LSTrackItem.h"
#import "LSTrackQueue.h"

@interface LSSearchResultTableViewCell : UITableViewCell {
    NSLayoutConstraint *containerViewLeading;
}
@property (nonatomic, readonly) LSTrackItem *trackItem;
@property (nonatomic, strong) UIImage *artImage;
@property (nonatomic, strong) NSString *song;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) NSString *URI;
- (void)animatePan:(UIPanGestureRecognizer *)recognizer;
@end
