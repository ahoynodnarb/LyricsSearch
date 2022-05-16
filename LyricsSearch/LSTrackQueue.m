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

- (void)enqueue:(LSTrackItem *)item {
    [self.nextTracks addObject:item];
}

- (NSString *)description {
    NSMutableArray *allItems = [self.previousTracks mutableCopy];
    [allItems addObject:self.currentTrack];
    [allItems addObjectsFromArray:self.nextTracks];
    return [allItems description];
}

@end
