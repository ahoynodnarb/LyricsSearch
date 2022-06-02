//
//  LSQueueTableViewController.h
//  LyricsSearch
//
//  Created by Brandon Yao on 5/8/22.
//

#import <UIKit/UIKit.h>
#import "LSTrackItem.h"
#import "LSPlayerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSQueueTableViewController : UITableViewController
@property (nonatomic, strong) LSPlayerModel *playerModel;
- (instancetype)initWithPlayerModel:(LSPlayerModel *)playerModel;
@end

NS_ASSUME_NONNULL_END
