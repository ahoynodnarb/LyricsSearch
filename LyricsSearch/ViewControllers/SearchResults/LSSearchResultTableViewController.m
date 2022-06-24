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
@property (nonatomic, strong) NSMutableDictionary *cachedData;
@end

@implementation LSSearchResultTableViewController

- (instancetype)initWithSearchTerm:(NSString *)searchTerm {
    if(self = [super init]) {
        self.searchTerm = searchTerm;
        self.cachedData = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setSearchTerm:(NSString *)searchTerm {
    _searchTerm = searchTerm;
    self.searchResults = nil;
    self.currentPage = 1;
}

- (void)loadNewPage {
    [self displayMoreResults];
}

- (void)loadNextPageWithCompletion:(void(^)(void))completion {
    [LSDataManager infoForSearchTerm:self.searchTerm page:self.currentPage completion:^(NSArray *info) {
        if([info count] != 0) {
            if(!self.searchResults) self.searchResults = info;
            else self.searchResults = [self.searchResults arrayByAddingObjectsFromArray:info];
        }
        completion();
    }];
    self.currentPage++;
}

- (void)displayMoreResults {
    [self loadNextPageWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.searchResults count] == 0) [self showErrorLabelWithMessage:@"No search results found"];
            else self.errorMessageLabel.hidden = YES;
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
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[LSSearchResultTableViewCell class] forCellReuseIdentifier:@"Cell"];
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
    NSDictionary *result = self.searchResults[indexPath.section];
    cell.song = result[@"songName"];
    cell.artist = result[@"artistName"];
    cell.duration = [result[@"duration"] longValue];
    cell.URI = result[@"URI"];
    [self loadArtworkForCell:cell atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    recognizer.delegate = cell;
    [cell addGestureRecognizer:recognizer];
    return cell;
}

- (void)loadArtworkForCell:(LSSearchResultTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *entry = self.cachedData[cell.URI];
    if(entry) {
        NSData *imageData = entry[@"imageData"];
        if(imageData) {
            UIImage *artworkImage = [UIImage imageWithData:imageData];
            cell.artImage = artworkImage;
            return;
        }
    }
    NSDictionary *result = self.searchResults[indexPath.section];
    NSURL *artworkURL = result[@"artURL"];
    [LSDataManager imageDataForURL:artworkURL completion:^(NSData *data){
        if(cell.URI) [self.cachedData setObject:@{@"imageData": data} forKey:cell.URI];
        UIImage *artworkImage = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.artImage = artworkImage;
        });
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSSearchResultTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    LSTrackItem *currentTrack = cell.trackItem;
    [self.playerModel setCurrentItem:currentTrack useSpotify:[self.playerModel spotifyConnected]];
    [self.playerModel.trackPresenter presentTrack:currentTrack];
}

@end
