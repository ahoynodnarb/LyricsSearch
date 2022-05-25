//
//  LSPlayerDelegate.h
//  LyricsSearch
//
//  Created by Brandon Yao on 5/23/22.
//

#import <Foundation/Foundation.h>

@protocol LSPlayerDelegate <NSObject>
- (void)removedTrackAtIndex:(NSInteger)index;
- (void)movedTrackAtIndex:(NSInteger)from toIndex:(NSInteger)to;
- (void)enqueuedTrack;
- (void)currentTrackChanged;
- (void)playbackStateChanged;
- (void)elapsedTimeChanged;
- (void)connectedToSpotify;
- (void)disconnectedFromSpotify;
- (void)playbackEnded;
@end
