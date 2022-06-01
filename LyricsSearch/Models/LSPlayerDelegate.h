//
//  LSPlayerDelegate.h
//  LyricsSearch
//
//  Created by Brandon Yao on 5/23/22.
//

#import <Foundation/Foundation.h>
#import "LSTrackItem.h"

@protocol LSPlayerDelegate <NSObject>
- (void)removedTrackAtIndex:(NSInteger)index;
- (void)movedTrackAtIndex:(NSInteger)from toIndex:(NSInteger)to;
- (void)enqueuedTrack:(LSTrackItem *)track;
- (void)currentTrackChanged:(LSTrackItem *)currentTrack playingNextTrack:(BOOL)playingNextTrack;
- (void)playbackStateChanged:(BOOL)state;
- (void)elapsedTimeChanged:(NSInteger)elapsedTime;
- (void)playbackEnded;
- (void)connectedToSpotify;
- (void)disconnectedFromSpotify;
@end
