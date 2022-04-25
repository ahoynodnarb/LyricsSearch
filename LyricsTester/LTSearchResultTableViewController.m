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

- (instancetype)initWithSearchResults:(NSArray *)searchResults {
    if(self = [super init]) {
        self.searchResults = searchResults;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[LTSearchResultTableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.searchResults count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
    NSArray *lyrics = [LTDataManager lyricsForSong:song artist:artist];
    UIImage *backgroundImage = cell.artImageView.image;
    if(!self.lyricsViewController) self.lyricsViewController = [[LTLyricsViewController alloc] init];
    self.lyricsViewController.lyrics = lyrics;
    self.lyricsViewController.song = song;
    self.lyricsViewController.artist = artist;
    self.lyricsViewController.backgroundImage = backgroundImage;
    [self presentViewController:self.lyricsViewController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
@end
