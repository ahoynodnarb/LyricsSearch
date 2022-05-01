//
//  LTSongSelectionViewController.m
//  LyricsTester
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
        self.currentPage = 1;
        [self loadNextPage];
    }
    return self;
}

- (void)setSearchTerm:(NSString *)searchTerm {
    _searchTerm = searchTerm;
    self.searchResults = nil;
}

- (void)loadNextPage {
    NSArray *info = [LSDataManager infoForSearchTerm:self.searchTerm page:self.currentPage];
    if(!self.searchResults) self.searchResults = info;
    else self.searchResults = [self.searchResults arrayByAddingObjectsFromArray:info];
    self.currentPage++;
}

- (void)displayMoreResults {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadNextPage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [[LSTrackQueue sharedQueue] push:cell.trackItem];
    if(!self.lyricsViewController) self.lyricsViewController = [[LSLyricsViewController alloc] initWithTrackItem:cell.trackItem];
    else [self.lyricsViewController setPlayingTrack:cell.trackItem];
    [self presentViewController:self.lyricsViewController animated:YES completion:nil];
}

@end
