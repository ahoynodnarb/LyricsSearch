//
//  LSTrackQueue.h
//  LyricsSearch
//
//  Created by Brandon Yao on 4/29/22.
//

#import <Foundation/Foundation.h>
#import "LSTrackItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSTrackQueue : NSObject
@property (nonatomic, readonly) NSUInteger index;
+ (instancetype)sharedQueue;
- (LSTrackItem *)currentItem;
- (void)setCurrentItem:(LSTrackItem *)item;
- (void)enqueue:(LSTrackItem *)item;
- (void)decrement;
- (void)increment;
- (NSInteger)size;
@end

NS_ASSUME_NONNULL_END
