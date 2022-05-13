//
//  LSLyricsTableViewController.h
//  LyricsSearch
//
//  Created by Brandon Yao on 1/9/22.
//

#import <UIKit/UIKit.h>
#import "LSDataManager.h"
#import "LSLyricsTableViewCell.h"
#import "LSPlayerModel.h"
#import "LSTrackItem.h"

@interface LSLyricsTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *lyricsArray;
@property (nonatomic, strong) LSPlayerModel *playerModel;
- (instancetype)initWithLyrics:(NSArray *)lyrics playerModel:(LSPlayerModel *)playerModel;
- (void)updateTimestampForTime:(NSInteger)time;
- (void)updateElapsedTime:(NSInteger)elapsedTime;
- (void)setPlayingTrack:(LSTrackItem *)track;
- (void)reloadLyrics;
@end
