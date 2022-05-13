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
@property (nonatomic, assign) NSInteger elapsedTime;
@property (nonatomic, assign, getter=isPaused) BOOL paused;
@property (nonatomic, assign) BOOL shouldUpdate;
@property (nonatomic, readonly) NSArray *nextTracks;
@property (nonatomic, readonly) NSArray *previousTracks;
- (instancetype)initWithTrackQueue:(LSTrackQueue *)trackQueue;
- (void)playNextTrack;
- (void)playPreviousTrack;
- (void)beginTimer;
@end
