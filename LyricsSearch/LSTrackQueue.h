//
//  LSTrackQueue.h
//  LyricsSearch
//
//  Created by Brandon Yao on 4/29/22.
//

#import <Foundation/Foundation.h>
#import "LSTrackItem.h"

@interface LSTrackQueue : NSObject
@property (nonatomic, strong) NSMutableArray *previousTracks;
@property (nonatomic, strong) NSMutableArray *nextTracks;
@property (nonatomic, strong) LSTrackItem *currentTrack;
+ (instancetype)sharedQueue;
- (void)enqueue:(LSTrackItem *)item;
- (void)decrement;
- (void)increment;
- (NSInteger)size;
@end
