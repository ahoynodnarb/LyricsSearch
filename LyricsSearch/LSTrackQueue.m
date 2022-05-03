//
//  LSTrackQueue.m
//  LyricsSearch
//
//  Created by Brandon Yao on 4/29/22.
//

#import "LSTrackQueue.h"

@interface LSTrackQueue ()
@property (nonatomic, strong) NSMutableArray<LSTrackItem *> *queue;
@property (nonatomic, assign) NSUInteger index;
@end

@implementation LSTrackQueue
+ (instancetype)sharedQueue {
    static dispatch_once_t pred = 0;
    static LSTrackQueue *_sharedQueue = nil;
    dispatch_once(&pred, ^{
        _sharedQueue = [[self alloc] init];
        _sharedQueue.queue = [[NSMutableArray alloc] init];
    });
    return _sharedQueue;
}
- (void)setCurrentItem:(LSTrackItem *)item {
    [self.queue insertObject:item atIndex:self.index];
}
- (void)enqueue:(LSTrackItem *)item {
    [self.queue addObject:item];
}
- (LSTrackItem *)currentItem {
    if([self.queue count] <= self.index) return nil;
    return self.queue[self.index];
}
- (void)decrement {
    self.index--;
}
- (void)increment {
    self.index++;
}
- (NSInteger)size {
    return [self.queue count];
}
@end
