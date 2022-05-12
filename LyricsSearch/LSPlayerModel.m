//
//  LSPlayerModel.m
//  LyricsSearch
//
//  Created by Brandon Yao on 5/7/22.
//

#import "LSPlayerModel.h"

@interface LSPlayerModel ()
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
- (void)setPaused:(BOOL)paused {
    _paused = paused;
    if(paused) [self.timer invalidate];
    else [self beginTimer];
}
- (void)timerFired {
    if(!self.shouldUpdate) return;
    self.elapsedTime += 10;
    if(self.elapsedTime >= self.trackDuration) {
        [self trackEnded];
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
    if(!currentItem) {
        [self resetTimer];
        return;
    }
    self.trackDuration = currentItem.duration * 1000;
    [self restartTimer];
}
- (void)trackEnded {
    [self resetTimer];
    self.currentItem = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"trackEnded" object:nil];
}
@end
