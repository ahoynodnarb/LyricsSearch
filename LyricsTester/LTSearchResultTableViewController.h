//
//  LTSongSelectionViewController.h
//  LyricsTester
//
//  Created by Brandon Yao on 4/21/22.
//

#import <UIKit/UIKit.h>
#import "LTLyricsViewController.h"

@interface LTSearchResultTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) LTLyricsViewController *lyricsViewController;
- (void)loadNextPage;
- (instancetype)initWithSearchTerm:(NSString *)searchTerm;
@end
