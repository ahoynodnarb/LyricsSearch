//
//  LSTrackQueue.m
//  LyricsSearch
//
//  Created by Brandon Yao on 4/29/22.
//

#import "LSTrackQueue.h"

@interface LSTrackQueue ()

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
    NSLog(@"%@ %@ %@", self.previousTracks, self.currentTrack, self.nextTracks);
}
- (void)enqueue:(LSTrackItem *)item {
    [self.nextTracks addObject:item];
    NSLog(@"%@ %@ %@", self.previousTracks, self.currentTrack, self.nextTracks);
}
- (void)decrement {
    if(self.currentTrack) [self.nextTracks insertObject:self.currentTrack atIndex:0];
    if([self.previousTracks count] == 0) _currentTrack = nil;
    else {
        _currentTrack = self.previousTracks[self.previousTracks.count - 1];
        [self.previousTracks removeLastObject];
    }
    NSLog(@"%@ %@ %@", self.previousTracks, self.currentTrack, self.nextTracks);
}
- (void)increment {
    if(self.currentTrack) [self.previousTracks addObject:self.currentTrack];
    if([self.nextTracks count] == 0) _currentTrack = nil;
    else {
        _currentTrack = self.nextTracks[0];
        [self.nextTracks removeObjectAtIndex:0];
    }
    NSLog(@"%@ %@ %@", self.previousTracks, self.currentTrack, self.nextTracks);
}
- (NSInteger)size {
    return [self.previousTracks count] + [self.nextTracks count] + 1;
}
@end
