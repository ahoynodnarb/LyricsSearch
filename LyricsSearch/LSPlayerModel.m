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
}

- (instancetype)initWithTrackQueue:(LSTrackQueue *)trackQueue {
    if(self = [super init]) {
        self.trackQueue = trackQueue;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseFiring) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeFiring) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (NSArray *)nextTracks {
    return [self.trackQueue.nextTracks copy];
}

- (NSArray *)previousTracks {
    return [self.trackQueue.previousTracks copy];
}

- (void)pauseFiring {
    if([self spotifyConnected] || !self.currentItem) return;
    self.backgroundTime = CFAbsoluteTimeGetCurrent();
    [self.timer invalidate];
}

- (void)resumeFiring {
    if([self spotifyConnected] || !self.currentItem) return;
    CFTimeInterval offset = CFAbsoluteTimeGetCurrent() - self.backgroundTime;
    NSInteger ms = offset * 1000;
    self.elapsedTime += ms;
    self.backgroundTime = 0;
    [self beginTimer];
}

- (void)setPaused:(BOOL)paused {
    if(!self.trackQueue.currentTrack || paused == _paused) return;
    _paused = paused;
    if(paused) {
        [self.timer invalidate];
        [self.appRemote.playerAPI pause:nil];
    }
    else {
        [self beginTimer];
        [self.appRemote.playerAPI resume:nil];
    }
}

- (void)timerFired {
    if([self spotifyConnected]) {
        [self.appRemote.playerAPI getPlayerState:^(id<SPTAppRemotePlayerState> result, NSError *error){
            self.elapsedTime = [result playbackPosition];
        }];
        return;
    }
    self.elapsedTime += 10;
    if(self.elapsedTime >= self.trackDuration) {
        [self playNextTrack];
        return;
    }
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

- (void)setCurrentItem:(LSTrackItem *)currentItem useSpotify:(BOOL)useSpotify {
    if([self spotifyConnected] && useSpotify) {
        if(_currentItem) [self.appRemote.playerAPI play:currentItem.URI callback:nil];
    }
    else self.trackQueue.currentTrack = currentItem;
    _currentItem = currentItem;
    [self resetPlayerForTrack:currentItem];
    if(_currentItem) [[NSNotificationCenter defaultCenter] postNotificationName:@"trackChanged" object:nil userInfo:@{@"playingNextTrack": @(NO)}];
    else [[NSNotificationCenter defaultCenter] postNotificationName:@"playbackEnded" object:nil];
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
}

- (void)playNextTrack {
    if([self spotifyConnected]) {
        [self.appRemote.playerAPI skipToNext:nil];
        return;
    }
    if(self.trackQueue.currentTrack) [self.trackQueue.previousTracks addObject:self.trackQueue.currentTrack];
    if([self.trackQueue.nextTracks count] == 0) self.currentItem = nil;
    else {
        self.currentItem = self.trackQueue.nextTracks[0];
        [self.trackQueue.nextTracks removeObjectAtIndex:0];
    }
}

- (void)playPreviousTrack {
    if([self spotifyConnected]) {
        [self.appRemote.playerAPI skipToPrevious:nil];
        return;
    }
    if(self.trackQueue.currentTrack) [self.trackQueue.nextTracks insertObject:self.trackQueue.currentTrack atIndex:0];
    if([self.trackQueue.previousTracks count] == 0) self.currentItem = nil;
    else {
        self.currentItem = self.trackQueue.previousTracks[[self.trackQueue.previousTracks count] - 1];
        [self.trackQueue.previousTracks removeLastObject];
    }
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didDisconnectWithError:(nullable NSError *)error {
    NSLog(@"disconnected");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"spotifyDisconnected" object:nil];
}

- (void)appRemote:(nonnull SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(nullable NSError *)error {
    NSLog(@"failed");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"spotifyDisconnected" object:nil];
}

- (void)appRemoteDidEstablishConnection:(nonnull SPTAppRemote *)appRemote {
    NSLog(@"connected");
    self.appRemote.playerAPI.delegate = self;
    [self.appRemote.playerAPI subscribeToPlayerState:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"spotifyConnected" object:nil];
}

- (void)playerStateDidChange:(nonnull id<SPTAppRemotePlayerState>)playerState {
    id<SPTAppRemoteTrack> track = playerState.track;
    if(![track.URI isEqualToString:self.currentItem.URI]) {
        LSTrackItem *item = [[LSTrackItem alloc] initWithArtImage:nil songName:track.name artistName:track.artist.name duration:track.duration URI:track.URI];
        [self setCurrentItem:item useSpotify:NO];
        self.trackDuration = track.duration;
        [self.appRemote.imageAPI fetchImageForItem:track withSize:CGSizeMake(100,100) callback:^(UIImage *result, NSError *error) {
            self.currentItem.artImage = result;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"trackChanged" object:nil userInfo:@{@"playingNextTrack": @(NO)}];
        }];
    }
    if(self.paused != playerState.paused) self.paused = playerState.paused;
    if(self.elapsedTime != playerState.playbackPosition) self.elapsedTime = playerState.playbackPosition;
}

@end
