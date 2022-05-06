//
//  LSTrackQueue.m
//  LyricsSearch
//
//  Created by Brandon Yao on 4/29/22.
//

#import "LSTrackQueue.h"

@interface LSTrackQueue ()
@property (nonatomic, strong) NSMutableArray<LSTrackItem *> *queue;
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
- (void)setIndex:(NSUInteger)index {
    _index = index;
}
- (void)setCurrentItem:(LSTrackItem *)item {
    [self.queue insertObject:item atIndex:self.index];
    NSLog(@"%@", self.queue);
}
- (void)enqueue:(LSTrackItem *)item {
    [self.queue addObject:item];
    NSLog(@"%@", self.queue);
}
- (LSTrackItem *)currentItem {
    NSLog(@"%@", self.queue);
    if([self.queue count] <= self.index) return nil;
    return self.queue[self.index];
}
- (void)decrement {
    NSLog(@"%@", self.queue);
    self.index--;
}
- (void)increment {
    NSLog(@"%@", self.queue);
    self.index++;
}
- (NSInteger)size {
    NSLog(@"%@", self.queue);
    return [self.queue count];
}
@end
