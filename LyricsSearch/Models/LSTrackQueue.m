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
- (instancetype)init {
    if(self = [super init]) self.allTracks = [[NSMutableArray alloc] initWithCapacity:1];
    return self;
}

- (void)enqueue:(LSTrackItem *)item {
    [self.allTracks addObject:item];
}

- (void)moveTrackAtIndex:(NSInteger)from toIndex:(NSInteger)to {
    if(0 > from || [self.allTracks count] <= from) return;
    if(0 > to || [self.allTracks count] <= to) return;
    [self.allTracks exchangeObjectAtIndex:from withObjectAtIndex:to];
}

- (void)removeTrackAtIndex:(NSInteger)index {
    if(0 > index || [self.allTracks count] <= index) return;
    [self.allTracks removeObjectAtIndex:index];
}

- (void)playNextTrack {
//    if(self.currentTrackPosition >= [self.allTracks count]) return;
    if(self.currentTrackPosition == [self.allTracks count] - 1) {
        self.currentTrack = nil;
        return;
    }
    self.currentTrackPosition++;
}

- (void)playPreviousTrack {
//    if(self.currentTrackPosition < 0) return;
    if(self.currentTrackPosition == 0) {
        self.currentTrack = nil;
        return;
    }
    self.currentTrackPosition--;
}

- (void)setCurrentTrack:(LSTrackItem *)currentTrack {
    _currentTrack = currentTrack;
    if(!currentTrack) return;
    [self.allTracks replaceObjectAtIndex:self.currentTrackPosition withObject:currentTrack];
}

//- (LSTrackItem *)currentTrack {
//    return -1 < self.currentTrackPosition < [self.allTracks count] ? self.allTracks[self.currentTrackPosition] : nil;
//}

@end
