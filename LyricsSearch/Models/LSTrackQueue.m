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
    if(self = [super init]) {
        self.previousTracks = [[NSMutableArray alloc] init];
        self.nextTracks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)indexInBounds:(NSInteger)index {
    return -1 < index < [self.allTracks count];
}

- (void)enqueue:(LSTrackItem *)item {
    [self.nextTracks addObject:item];
}

- (NSArray *)allTracks {
    NSMutableArray *allItems = [[NSMutableArray alloc] init];
    if(self.previousTracks) [allItems addObjectsFromArray:self.previousTracks];
    if(self.currentTrack) [allItems addObject:self.currentTrack];
    if(self.nextTracks) [allItems addObjectsFromArray:self.nextTracks];
    return [NSArray arrayWithArray:allItems];
}

- (NSString *)description {
    NSMutableArray *allItems = [[NSMutableArray alloc] init];
    if(self.previousTracks) [allItems addObjectsFromArray:self.previousTracks];
    if(self.currentTrack) [allItems addObject:self.currentTrack];
    if(self.nextTracks) [allItems addObjectsFromArray:self.nextTracks];
    return [allItems description];
}

- (void)playNextTrack {
    if(self.currentTrack) [self.previousTracks addObject:self.currentTrack];
    self.currentTrack = [self.nextTracks firstObject];
    if([self.nextTracks count] != 0) [self.nextTracks removeObjectAtIndex:0];
}

- (void)playPreviousTrack {
    if(self.currentTrack) [self.nextTracks insertObject:self.currentTrack atIndex:0];
    self.currentTrack = [self.previousTracks lastObject];
    if([self.previousTracks count] != 0) [self.previousTracks removeLastObject];
}

- (void)removeTrackAtIndex:(NSInteger)index {
    if(![self indexInBounds:index]) return;
    NSInteger position = [self currentTrackPosition];
    if(index < position) [self.previousTracks removeObjectAtIndex:index];
    else if (index > position) [self.nextTracks removeObjectAtIndex:index - position - 1];
    else {
        self.currentTrack = nil;
        [self playNextTrack];
    }
}

- (void)moveTrackAtIndex:(NSInteger)from toIndex:(NSInteger)to {
    if(![self indexInBounds:from] || ![self indexInBounds:to]) return;
    
}

- (NSInteger)currentTrackPosition {
    return [self.previousTracks count];
}

@end
