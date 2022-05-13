//
//  LSSearchResultTableViewController.m
//  LyricsSearch
//
//  Created by Brandon Yao on 4/21/22.
//

#import "LSSearchResultTableViewController.h"

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
            NSLog(@"%@", self.searchResults);
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
        self.currentPage++;
        completion();
    }];
}

- (void)displayMoreResults {
    [self loadNextPageWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self loadNextPage];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
//    });
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

- (LSSearchResultTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *result = [self.searchResults objectAtIndex:[indexPath section]];
    NSData *artData = [result objectForKey:@"artData"];
    cell.artImage = [UIImage imageWithData:artData];
    cell.song = [result objectForKey:@"songName"];
    cell.artist = [result objectForKey:@"artistName"];
    cell.duration = [[result objectForKey:@"duration"] longValue];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LSSearchResultTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.playerModel.currentItem = cell.trackItem;
    LSTrackItem *currentTrack = self.playerModel.currentItem;
    if(!self.lyricsViewController) {
        [LSDataManager lyricsForSong:currentTrack.songName artist:currentTrack.artistName completion:^(NSArray *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *songName = currentTrack.songName;
                NSString *artistName = currentTrack.artistName;
                UIImage *artImage = currentTrack.artImage;
                NSInteger duration = currentTrack.duration;
                self.lyricsViewController = [[LSLyricsViewController alloc] initWithLyrics:info song:songName artist:artistName image:artImage duration:duration];
                [self presentViewController:self.lyricsViewController animated:YES completion:nil];
            });
        }];
    }
    else {
        [self.lyricsViewController setPlayingTrack:currentTrack];
        [self presentViewController:self.lyricsViewController animated:YES completion:nil];
    }
}

@end
