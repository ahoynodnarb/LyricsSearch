//
//  NSMutableArray+NSMutableArray_Move.h
//  LyricsSearch
//
//  Created by Brandon Yao on 5/31/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (Move)

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end

NS_ASSUME_NONNULL_END
