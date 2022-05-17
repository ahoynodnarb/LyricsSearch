//
//  LSTrackPresenter.h
//  LyricsSearch
//
//  Created by Brandon Yao on 5/14/22.
//

#import <Foundation/Foundation.h>
#import "LSTrackItem.h"

@protocol LSTrackPresenter <NSObject>
- (void)presentTrack:(LSTrackItem *)track;
@end
