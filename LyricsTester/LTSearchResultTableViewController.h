//
//  LTSongSelectionViewController.h
//  LyricsTester
//
//  Created by Brandon Yao on 4/21/22.
//

#import <UIKit/UIKit.h>
#import "LTLyricsViewController.h"

@interface LTSearchResultTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) LTLyricsViewController *lyricsViewController;
- (instancetype)initWithSearchResults:(NSArray *)searchResults;
@end
