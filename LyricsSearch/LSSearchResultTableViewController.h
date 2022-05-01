//
//  LTSongSelectionViewController.h
//  LyricsTester
//
//  Created by Brandon Yao on 4/21/22.
//

#import <UIKit/UIKit.h>
#import "LSDataManager.h"
#import "LSLyricsViewController.h"
#import "LSSearchResultTableViewCell.h"

@interface LSSearchResultTableViewController : UITableViewController
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) LSLyricsViewController *lyricsViewController;
- (void)loadNextPage;
- (instancetype)initWithSearchTerm:(NSString *)searchTerm;
@end
