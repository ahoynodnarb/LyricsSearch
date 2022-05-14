//
//  LSPlayerModel.h
//  LyricsSearch
//
//  Created by Brandon Yao on 5/7/22.
//

#import <Foundation/Foundation.h>
#import "LSTrackItem.h"
#import "LSTrackQueue.h"
#import <SpotifyiOS/SpotifyiOS.h>

@interface LSPlayerModel : NSObject <SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate>
@property (nonatomic, strong) SPTAppRemote *appRemote;
@property (nonatomic, assign) BOOL shouldUpdate;
@property (nonatomic, assign) BOOL paused;
@property (nonatomic, strong) LSTrackItem *currentItem;
@property (nonatomic, readonly) NSInteger elapsedTime;
@property (nonatomic, readonly) NSArray *nextTracks;
@property (nonatomic, readonly) NSArray *previousTracks;
- (instancetype)initWithTrackQueue:(LSTrackQueue *)trackQueue;
- (void)enqueue:(LSTrackItem *)track;
- (void)playNextTrack;
- (void)playPreviousTrack;
- (void)seek:(NSInteger)position;
@end
