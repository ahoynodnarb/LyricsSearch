//
//  LSSearchResultTableViewController.h
//  LyricsSearch
//
//  Created by Brandon Yao on 4/21/22.
//

#import <UIKit/UIKit.h>
#import "LSPlayerModel.h"

@interface LSSearchResultTableViewController : UITableViewController
@property (nonatomic, strong) LSPlayerModel *playerModel;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) UILabel *errorMessageLabel;
- (instancetype)initWithSearchTerm:(NSString *)searchTerm;
- (void)loadNewPage;
@end
