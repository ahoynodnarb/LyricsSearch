//
//  LSPlayerModel.m
//  LyricsSearch
//
//  Created by Brandon Yao on 5/7/22.
//

#import "LSPlayerModel.h"

@interface LSPlayerModel ()
@property (nonatomic, assign) CFAbsoluteTime backgroundTime;
@property (nonatomic, strong) LSTrackQueue *trackQueue;
@property (nonatomic, assign) NSInteger trackDuration;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LSPlayerModel

- (void)seek:(NSInteger)position {
    if([self spotifyConnected]) [self.appRemote.playerAPI seekToPosition:position callback:nil];
    self.elapsedTime = position;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)spotifyConnected {
    return [self.appRemote isConnected];
}

- (void)setElapsedTime:(NSInteger)elapsedTime {
    _elapsedTime = elapsedTime;
    [self.delegate elapsedTimeChanged:elapsedTime];
}

- (NSInteger)currentTrackPosition {
    return self.trackQueue.currentTrackPosition;
}

- (NSArray *)nextTracks {
    return self.trackQueue.nextTracks;
}

- (NSArray *)previousTracks {
    return self.trackQueue.previousTracks;
}

- (NSArray *)allTracks {
    return [self.trackQueue allTracks];
}

- (instancetype)initWithTrackQueue:(LSTrackQueue *)trackQueue {
    if(self = [super init]) {
        self.trackQueue = trackQueue;
    }
    return self;
}

- (void)pauseFiring {
    self.backgroundTime = CFAbsoluteTimeGetCurrent();
    [self.timer invalidate];
}

- (void)resumeFiring {
    CFTimeInterval offset = CFAbsoluteTimeGetCurrent() - self.backgroundTime;
    NSInteger ms = offset * 1000;
    self.elapsedTime += ms;
    self.backgroundTime = 0;
    [self.timer invalidate];
    [self beginTimer];
}

- (void)setPaused:(BOOL)paused {
    if(!self.currentItem || paused == _paused) return;
    _paused = paused;
    if(paused) {
        [self.timer invalidate];
        [self.appRemote.playerAPI pause:nil];
    }
    else {
        [self beginTimer];
        [self.appRemote.playerAPI resume:nil];
    }
    if(self.delegate) [self.delegate playbackStateChanged:paused];
}

- (void)timerFired {
    if([self spotifyConnected]) {
        [self.appRemote.playerAPI getPlayerState:^(id<SPTAppRemotePlayerState> result, NSError *error) {
            self.elapsedTime = [result playbackPosition];
        }];
        return;
    }
    self.elapsedTime += 10;
    if(self.elapsedTime >= self.trackDuration) [self playNextTrack];
}

- (void)beginTimer {
    self.timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)resetTimer {
    [self.timer invalidate];
    self.elapsedTime = 0;
}

- (void)restartTimer {
    [self resetTimer];
    [self beginTimer];
}

- (void)setCurrentItem:(LSTrackItem *)currentItem useSpotify:(BOOL)useSpotify useCache:(BOOL)useCache {
    if([self spotifyConnected]) {
        if(_currentItem && useSpotify) [self.appRemote.playerAPI play:currentItem.URI callback:nil];
    }
    else self.trackQueue.currentTrack = currentItem;
    _currentItem = currentItem;
    [self resetPlayerForTrack:currentItem];
    if(!self.delegate) return;
    if(currentItem) [self.delegate currentTrackChanged:currentItem playingNextTrack:useCache];
    else [self.delegate playbackEnded];
}

- (void)setCurrentItem:(LSTrackItem *)currentItem useSpotify:(BOOL)useSpotify {
    [self setCurrentItem:currentItem useSpotify:useSpotify useCache:NO];
}

- (void)setCurrentItem:(LSTrackItem *)currentItem {
    [self setCurrentItem:currentItem useSpotify:NO];
}

- (void)resetPlayerForTrack:(LSTrackItem *)track {
    if(!track) {
        [self resetTimer];
        return;
    }
    [self restartTimer];
    self.trackDuration = track.duration;
}

- (void)enqueue:(LSTrackItem *)trackItem {
    if([self spotifyConnected]) {
        [self.appRemote.playerAPI enqueueTrackUri:trackItem.URI callback:nil];
        return;
    }
    [self.trackQueue enqueue:trackItem];
    if(self.delegate) [self.delegate enqueuedTrack:trackItem];
}

- (void)moveTrackAtIndex:(NSInteger)from toIndex:(NSInteger)to {
    [self.trackQueue moveTrackAtIndex:from toIndex:to];
    if(self.delegate) [self.delegate movedTrackAtIndex:from toIndex:to];
}

- (void)removeTrackAtIndex:(NSInteger)index {
    [self.trackQueue removeTrackAtIndex:index];
    if(self.delegate) [self.delegate removedTrackAtIndex:index];
}

- (void)playNextTrack {
    if([self spotifyConnected]) {
        [self.appRemote.playerAPI skipToNext:nil];
        return;
    }
    [self.trackQueue playNextTrack];
    self.currentItem = [self.trackQueue currentTrack];
}

- (void)playPreviousTrack {
    if([self spotifyConnected]) {
        [self.appRemote.playerAPI skipToPrevious:nil];
        return;
    }
    [self.trackQueue playPreviousTrack];
    self.currentItem = [self.trackQueue currentTrack];
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didDisconnectWithError:(nullable NSError *)error {
    NSLog(@"disconnected");
    if(self.delegate) [self.delegate disconnectedFromSpotify];
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(nullable NSError *)error {
    NSLog(@"failed");
    if(self.delegate) [self.delegate disconnectedFromSpotify];
}

- (void)appRemoteDidEstablishConnection:(nonnull SPTAppRemote *)appRemote {
    NSLog(@"connected");
    self.appRemote.playerAPI.delegate = self;
    [self.appRemote.playerAPI subscribeToPlayerState:nil];
    if(self.delegate) [self.delegate connectedToSpotify];
}

- (void)playerStateDidChange:(nonnull id<SPTAppRemotePlayerState>)playerState {
    id<SPTAppRemoteTrack> track = playerState.track;
    if(![track.URI isEqualToString:self.currentItem.URI]) {
        LSTrackItem *item = [[LSTrackItem alloc] initWithArtImage:nil songName:track.name artistName:track.artist.name duration:track.duration URI:track.URI];
        [self setCurrentItem:item useSpotify:NO];
        self.trackDuration = track.duration;
        self.elapsedTime = playerState.playbackPosition;
        [self.appRemote.imageAPI fetchImageForItem:track withSize:CGSizeMake(100,100) callback:^(UIImage *result, NSError *error) {
            self.currentItem.artImage = result;
            if(self.delegate) [self.delegate currentTrackChanged:item playingNextTrack:NO];
        }];
    }
    if(self.paused != playerState.paused) self.paused = playerState.paused;
    if(self.elapsedTime != playerState.playbackPosition) self.elapsedTime = playerState.playbackPosition;
}

- (NSUInteger)count {
    return [self.previousTracks count] + [self.nextTracks count] + (self.currentItem != nil);
}

@end
