//
//  LSPlayerModel.h
//  LyricsSearch
//
//  Created by Brandon Yao on 5/7/22.
//

#import <Foundation/Foundation.h>
#import "LSPlayerModelDelegate.h"
#import "LSTrackItem.h"

@interface LSPlayerModel : NSObject
@property (nonatomic, weak) id<LSPlayerModelDelegate> delegate;
@property (nonatomic, strong) LSTrackItem *currentItem;
@property (nonatomic, assign, getter=isPaused) BOOL paused;
@property (nonatomic, assign) BOOL shouldUpdate;
+ (instancetype)sharedPlayer;
- (void)seek:(NSInteger)position;
@end
