//
//  NSMutableArray+Move.m
//  LyricsSearch
//
//  Created by Brandon Yao on 5/31/22.
//

#import "NSMutableArray+Move.h"

@implementation NSMutableArray (Move)

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex < toIndex) toIndex--;
    id object = [self objectAtIndex:fromIndex];
    [self removeObjectAtIndex:fromIndex];
    [self insertObject:object atIndex:toIndex];
}

@end
