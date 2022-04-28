//
//  LTSongSelectionViewController.m
//  LyricsTester
//
//  Created by Brandon Yao on 4/21/22.
//

#import "LTSearchResultTableViewController.h"
#import "LTSearchResultTableViewCell.h"
#import "LTLyricsViewController.h"
#import "LTDataManager.h"

@interface LTSearchResultTableViewController ()
@end

@implementation LTSearchResultTableViewController

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
    NSArray *info = [LTDataManager infoForSearchTerm:self.searchTerm page:self.currentPage];
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
    [self.tableView registerClass:[LTSearchResultTableViewCell class] forCellReuseIdentifier:@"Cell"];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == roundf(scrollView.contentSize.height-scrollView.frame.size.height)) {
        NSLog(@"reached the bottom");
    }
}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    NSLog(@"Scrolling");
//    if(scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
//        NSLog(@"Scrolled past");
//        [self displayMoreResults];
//    }
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) [self displayMoreResults];
}

- (LTSearchResultTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *result = [self.searchResults objectAtIndex:[indexPath section]];
    NSData *artData = [result objectForKey:@"artData"];
    cell.artImageView.image = [UIImage imageWithData:artData];
    cell.titleLabel.text = [result objectForKey:@"songName"];
    cell.authorLabel.text = [result objectForKey:@"artistName"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LTSearchResultTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *song = cell.titleLabel.text;
    NSString *artist = cell.authorLabel.text;
    UIImage *backgroundImage = cell.artImageView.image;
    NSArray *lyrics = [LTDataManager lyricsForSong:song artist:artist];
    if(!self.lyricsViewController) self.lyricsViewController = [[LTLyricsViewController alloc] init];
    self.lyricsViewController.song = song;
    self.lyricsViewController.artist = artist;
    self.lyricsViewController.backgroundImage = backgroundImage;
    self.lyricsViewController.lyrics = lyrics;
    [self presentViewController:self.lyricsViewController animated:YES completion:nil];
}

@end
