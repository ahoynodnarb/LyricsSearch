//
//  LSPlayerModel.h
//  LyricsSearch
//
//  Created by Brandon Yao on 5/7/22.
//

#import <Foundation/Foundation.h>
#import "LSTrackItem.h"
#import "LSTrackQueue.h"

@interface LSPlayerModel : NSObject
@property (nonatomic, strong) LSTrackItem *currentItem;
@property (nonatomic, assign) BOOL isPlaying;
+ (instancetype)sharedPlayer;
- (void)seek:(NSInteger)position;
- (void)unpauseTimer;
- (void)pauseTimer;
@end
