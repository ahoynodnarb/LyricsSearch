//
//  LTTableViewController.h
//  LyricsTester
//
//  Created by Brandon Yao on 1/9/22.
//

#import <UIKit/UIKit.h>
#import "LSTrackItem.h"
#import "LSLyricsTableViewCell.h"

@interface LSLyricsTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *lyricsArray;
@property (nonatomic, assign) NSInteger duration;
- (instancetype)initWithLyrics:(NSArray *)lyrics trackDuration:(NSInteger)duration;
- (void)trackChanged;
@end
