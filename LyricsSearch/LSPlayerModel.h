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
@property (nonatomic, assign, getter=isPaused) BOOL paused;
+ (instancetype)sharedPlayer;
- (void)seek:(NSInteger)position;
@end
