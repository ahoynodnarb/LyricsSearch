//
//  LSPlayerModelDelegate.h
//  LyricsSearch
//
//  Created by Brandon Yao on 5/9/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LSPlayerModelDelegate <NSObject>
- (void)updateElapsedTime:(NSInteger)elapsedTime;
- (void)trackEnded;
@end

NS_ASSUME_NONNULL_END
