//
//  LSSearchResultTableViewController.m
//  LyricsSearch
//
//  Created by Brandon Yao on 4/21/22.
//

#import "LSSearchResultTableViewController.h"
#import "LSDataManager.h"
#import "LSSearchResultTableViewCell.h"

@interface LSSearchResultTableViewController ()

@end

@implementation LSSearchResultTableViewController

- (instancetype)initWithSearchTerm:(NSString *)searchTerm {
    if(self = [super init]) {
        self.searchTerm = searchTerm;
    }
    return self;
}

- (void)setSearchTerm:(NSString *)searchTerm {
    _searchTerm = searchTerm;
    self.searchResults = nil;
}

- (void)loadNewPage {
    self.currentPage = 1;
    [self loadNextPageWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.searchResults count] == 0) [self showErrorLabelWithMessage:@"No search results found"];
            else {
                self.errorMessageLabel.hidden = YES;
                [self.tableView reloadData];
            }
        });
    }];
}

- (void)loadNextPageWithCompletion:(void(^)(void))completion {
    [LSDataManager infoForSearchTerm:self.searchTerm page:self.currentPage completion:^(NSArray *info) {    
        if(!self.searchResults) self.searchResults = info;
        else self.searchResults = [self.searchResults arrayByAddingObjectsFromArray:info];
        completion();
    }];
    self.currentPage++;
}

- (void)displayMoreResults {
    [self loadNextPageWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)showErrorLabelWithMessage:(NSString *)message {
    self.errorMessageLabel.text = message;
    self.errorMessageLabel.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.errorMessageLabel = [[UILabel alloc] init];
    self.errorMessageLabel.textColor = [UIColor whiteColor];
    self.errorMessageLabel.hidden = YES;
    self.errorMessageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.errorMessageLabel];
    [NSLayoutConstraint activateConstraints:@[
        [self.errorMessageLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.errorMessageLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor],
    ]];
    [self loadNewPage];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[LSSearchResultTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self displayMoreResults];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.searchResults count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) [self displayMoreResults];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    LSSearchResultTableViewCell *cell = (LSSearchResultTableViewCell *)recognizer.view;
    [cell animatePan:recognizer];
    if(recognizer.state == UIGestureRecognizerStateEnded) [self.playerModel enqueue:[cell trackItem]];
}

- (LSSearchResultTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *result = [self.searchResults objectAtIndex:[indexPath section]];
    NSData *artData = [result objectForKey:@"artData"];
    cell.artImage = [UIImage imageWithData:artData];
    cell.song = [result objectForKey:@"songName"];
    cell.artist = [result objectForKey:@"artistName"];
    cell.duration = [[result objectForKey:@"duration"] longValue];
    cell.URI = [result objectForKey:@"URI"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    recognizer.delegate = cell;
    [cell addGestureRecognizer:recognizer];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSSearchResultTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.playerModel.currentItem = cell.trackItem;
    LSTrackItem *currentTrack = self.playerModel.currentItem;
    [self.playerModel.trackPresenter presentTrack:currentTrack];
}

@end
