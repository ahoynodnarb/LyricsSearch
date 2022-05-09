//
//  LSTrackQueue.m
//  LyricsSearch
//
//  Created by Brandon Yao on 4/29/22.
//

#import "LSTrackQueue.h"

@interface LSTrackQueue ()
//@property (nonatomic, strong) NSMutableArray<LSTrackItem *> *queue;
@end

@implementation LSTrackQueue
+ (instancetype)sharedQueue {
    static dispatch_once_t pred = 0;
    static LSTrackQueue *_sharedQueue = nil;
    dispatch_once(&pred, ^{
        _sharedQueue = [[self alloc] init];
        _sharedQueue.previousTracks = [[NSMutableArray alloc] init];
        _sharedQueue.nextTracks = [[NSMutableArray alloc] init];
    });
    return _sharedQueue;
}
- (void)setCurrentTrack:(LSTrackItem *)track {
    if(self.currentTrack) [self.nextTracks insertObject:self.currentTrack atIndex:0];
    _currentTrack = track;
}
- (void)enqueue:(LSTrackItem *)item {
    [self.nextTracks addObject:item];
}
- (void)decrement {
    if(self.currentTrack) [self.nextTracks addObject:self.currentTrack];
    if([self.previousTracks count] == 0) self.currentTrack = nil;
    else {
        NSInteger lastIndex = self.previousTracks.count - 1;
        self.currentTrack = self.previousTracks[lastIndex];
        [self.previousTracks removeObjectAtIndex:lastIndex];
    }
}
- (void)increment {
    if(self.currentTrack) [self.previousTracks addObject:self.currentTrack];
    if([self.nextTracks count] == 0) self.currentTrack = nil;
    else {
        self.currentTrack = self.nextTracks[0];
        [self.nextTracks removeObjectAtIndex:0];
    }
}
- (NSInteger)size {
    return [self.previousTracks count] + [self.nextTracks count] + 1;
}
@end
