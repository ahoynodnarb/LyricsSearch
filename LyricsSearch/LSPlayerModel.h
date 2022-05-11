//
//  LSPlayerModel.h
//  LyricsSearch
//
//  Created by Brandon Yao on 5/7/22.
//

#import <Foundation/Foundation.h>
#import "LSTrackItem.h"

@interface LSPlayerModel : NSObject
@property (nonatomic, strong) LSTrackItem *currentItem;
@property (nonatomic, assign) NSInteger elapsedTime;
@property (nonatomic, assign, getter=isPaused) BOOL paused;
@property (nonatomic, assign) BOOL shouldUpdate;
+ (instancetype)sharedPlayer;
@end
