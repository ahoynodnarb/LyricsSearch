//
//  LSPlayerModel.h
//  LyricsSearch
//
//  Created by Brandon Yao on 5/7/22.
//

#import <Foundation/Foundation.h>
#import <SpotifyiOS/SpotifyiOS.h>
#import "LSTrackItem.h"
#import "LSTrackQueue.h"
#import "LSTrackPresenter.h"

@interface LSPlayerModel : NSObject <SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate>
@property (nonatomic, assign) BOOL paused;
@property (nonatomic, strong) SPTAppRemote *appRemote;
@property (nonatomic, strong) LSTrackItem *currentItem;
@property (nonatomic, readonly) NSArray *nextTracks;
@property (nonatomic, readonly) NSArray *previousTracks;
@property (nonatomic, readonly) BOOL spotifyConnected;
@property (nonatomic, readonly) NSInteger elapsedTime;
@property (nonatomic, weak) id<LSTrackPresenter> trackPresenter;
- (instancetype)initWithTrackQueue:(LSTrackQueue *)trackQueue;
- (void)enqueue:(LSTrackItem *)track;
- (void)playNextTrack;
- (void)playPreviousTrack;
- (void)seek:(NSInteger)position;
- (void)resumeFiring;
- (void)pauseFiring;
@end
