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
@property (nonatomic, readonly) NSArray *allTracks;
@property (nonatomic, readonly) NSInteger currentTrackPosition;
- (void)enqueue:(LSTrackItem *)item;
- (void)replaceTrackAtIndex:(NSInteger)index withTrack:(LSTrackItem *)track;
- (void)moveTrackAtIndex:(NSInteger)from toIndex:(NSInteger)to;
- (void)removeTrackAtIndex:(NSInteger)index;
- (void)playNextTrack;
- (void)playPreviousTrack;
@end
