//
//  LSPlayerModel.m
//  LyricsSearch
//
//  Created by Brandon Yao on 5/7/22.
//

#import "LSPlayerModel.h"

@interface LSPlayerModel ()
@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, assign) NSInteger seekPosition;
@property (nonatomic, assign) NSInteger trackDuration;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LSPlayerModel
+ (instancetype)sharedPlayer {
    static dispatch_once_t pred = 0;
    static LSPlayerModel *_sharedPlayer = nil;
    dispatch_once(&pred, ^{
        _sharedPlayer = [[self alloc] init];
    });
    return _sharedPlayer;
}
- (void)seek:(NSInteger)position {
    self.seekPosition = (CFAbsoluteTimeGetCurrent() * 1000) - position;
}
- (void)timerFired {
    NSInteger elapsedTime = (CFAbsoluteTimeGetCurrent() * 1000) - (self.startTime + self.seekPosition);
    if(elapsedTime >= self.trackDuration) {
        [self trackEnded];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"elapsedTimeUpdated" object:nil userInfo:@{@"elapsedTime": @(elapsedTime)}];
}
- (void)beginTimer {
    self.isPlaying = YES;
    self.timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)pauseTimer {
    self.isPlaying = NO;
    [self.timer invalidate];
    self.timer = nil;
}
- (void)unpauseTimer {
    [self beginTimer];
}
- (void)resetTimer {
    [self.timer invalidate];
    self.timer = nil;
    self.startTime = CFAbsoluteTimeGetCurrent() * 1000;
}
- (void)restartTimer {
    [self resetTimer];
    [self beginTimer];
}
- (void)setCurrentItem:(LSTrackItem *)currentItem {
    _currentItem = currentItem;
    if(!currentItem) {
        [self resetTimer];
        return;
    }
    self.trackDuration = currentItem.duration * 1000;
    [self restartTimer];
}
- (void)trackEnded {
    [self resetTimer];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"trackEnded" object:nil];
}
@end
