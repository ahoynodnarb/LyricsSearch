//
//  LSQueueModel.h
//  LyricsSearch
//
//  Created by Brandon Yao on 4/29/22.
//

#import <Foundation/Foundation.h>
#import "LSTrackItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSTrackQueue : NSObject
+ (instancetype)sharedQueue;
- (LSTrackItem *)currentItem;
- (void)push:(LSTrackItem *)item;
- (void)enqueue:(LSTrackItem *)item;
- (void)decrement;
- (void)increment;
- (void)setIndex:(NSUInteger)idx;
@end

NS_ASSUME_NONNULL_END
