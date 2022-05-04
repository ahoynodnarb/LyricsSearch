//
//  LSLyricsTableViewController.h
//  LyricsSearch
//
//  Created by Brandon Yao on 1/9/22.
//

#import <UIKit/UIKit.h>
#import "LSDataManager.h"
#import "LSLyricsTableViewCell.h"
#import "LSTrackItem.h"
#import "LSTrackQueue.h"

@interface LSLyricsTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *lyricsArray;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) BOOL playing;
- (instancetype)initWithLyrics:(NSArray *)lyrics trackDuration:(NSInteger)duration;
- (void)setPlayingTrack:(LSTrackItem *)track;
@end
