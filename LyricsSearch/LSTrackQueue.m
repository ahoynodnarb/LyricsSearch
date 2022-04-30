//
//  LSQueueModel.m
//  LyricsSearch
//
//  Created by Brandon Yao on 4/29/22.
//

#import "LSTrackQueue.h"

@interface LSTrackQueue (private)
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
- (void)push:(LSTrackItem *)item {
    if(![item isKindOfClass:[LSTrackItem class]]) return;
    [self.queue insertObject:item atIndex:0];
}
- (void)enqueue:(LSTrackItem *)item {
    if(![item isKindOfClass:[LSTrackItem class]]) return;
    [self.queue addObject:item];
}
- (LSTrackItem *)currentItem {
    if([self.queue count] <= self.index) return nil;
    return self.queue[self.index];
}
- (void)decrement {
    if(self.index == 0) return;
    else self.index--;
}
- (void)increment {
    if(self.index == [self.queue count] - 1) return;
    self.index++;
}
- (void)setIndex:(NSUInteger)idx {
    self.index = idx;
}
- (NSInteger)size {
    return [self.queue count];
}
@end
