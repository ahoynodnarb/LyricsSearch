//
//  LSTrackQueue.h
//  LyricsSearch
//
//  Created by Brandon Yao on 4/29/22.
//

#import <Foundation/Foundation.h>
#import "LSTrackItem.h"

@interface LSTrackQueue : NSObject
@property (nonatomic, strong) NSMutableArray *allTracks;
@property (nonatomic, strong) LSTrackItem *currentTrack;
@property (nonatomic, assign) NSInteger currentTrackPosition;
- (void)enqueue:(LSTrackItem *)item;
- (void)moveTrackAtIndex:(NSInteger)from toIndex:(NSInteger)to;
- (void)removeTrackAtIndex:(NSInteger)index;
- (void)playNextTrack;
- (void)playPreviousTrack;
@end
