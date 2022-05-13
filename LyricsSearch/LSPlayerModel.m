//
//  LSPlayerModel.m
//  LyricsSearch
//
//  Created by Brandon Yao on 5/7/22.
//

#import "LSPlayerModel.h"

@interface LSPlayerModel ()
@property (nonatomic, strong) LSTrackQueue *trackQueue;
@property (nonatomic, assign) NSInteger trackDuration;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LSPlayerModel
- (instancetype)initWithTrackQueue:(LSTrackQueue *)trackQueue {
    if(self = [super init]) {
        self.trackQueue = trackQueue;
    }
    return self;
}
- (NSArray *)nextTracks {
    return [self.trackQueue.nextTracks copy];
}
- (NSArray *)previousTracks {
    return [self.trackQueue.previousTracks copy];
}
- (void)setPaused:(BOOL)paused {
    _paused = paused;
    if(!self.trackQueue.currentTrack) return;
    if(paused) [self.timer invalidate];
    else [self beginTimer];
}
- (void)timerFired {
    if(!self.shouldUpdate) return;
    self.elapsedTime += 10;
    if(self.elapsedTime >= self.trackDuration) {
        [self playNextTrack];
        return;
    }
}
- (void)beginTimer {
    self.shouldUpdate = YES;
    self.timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)resetTimer {
    self.shouldUpdate = NO;
    [self.timer invalidate];
    self.elapsedTime = 0;
}
- (void)restartTimer {
    [self resetTimer];
    [self beginTimer];
}
- (void)setCurrentItem:(LSTrackItem *)currentItem {
    _currentItem = currentItem;
    self.trackQueue.currentTrack = currentItem;
    [self resetPlayerForTrack:currentItem];
    if(_currentItem) [[NSNotificationCenter defaultCenter] postNotificationName:@"trackChanged" object:nil userInfo:@{@"playingNextTrack": @(NO)}];
    else [[NSNotificationCenter defaultCenter] postNotificationName:@"playbackEnded" object:nil];
}
- (void)resetPlayerForTrack:(LSTrackItem *)track {
    if(!track) {
        [self resetTimer];
        return;
    }
    [self restartTimer];
    self.trackDuration = track.duration * 1000;
}
- (void)enqueue:(LSTrackItem *)trackItem {
    [self.trackQueue enqueue:trackItem];
}
- (void)playNextTrack {
    if(self.trackQueue.currentTrack) [self.trackQueue.previousTracks addObject:self.trackQueue.currentTrack];
    if([self.trackQueue.nextTracks count] == 0) self.currentItem = nil;
    else {
        self.currentItem = self.trackQueue.nextTracks[0];
        [self.trackQueue.nextTracks removeObjectAtIndex:0];
    }
}
- (void)playPreviousTrack {
    if(self.trackQueue.currentTrack) [self.trackQueue.nextTracks insertObject:self.trackQueue.currentTrack atIndex:0];
    if([self.trackQueue.previousTracks count] == 0) self.currentItem = nil;
    else {
        self.currentItem = self.trackQueue.previousTracks[[self.trackQueue.previousTracks count] - 1];
        [self.trackQueue.previousTracks removeLastObject];
    }
}
@end
