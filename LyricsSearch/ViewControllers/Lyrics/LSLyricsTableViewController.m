//
//  LSLyricsTableViewController.m
//  LyricsSearch
//
//  Created by Brandon Yao on 1/9/22.
//

#import "LSLyricsTableViewController.h"
#import "LSDataManager.h"
#import "LSLyricsTableViewCell.h"

@interface LSLyricsTableViewController ()

@end

@implementation LSLyricsTableViewController

- (instancetype)initWithLyrics:(NSArray *)lyrics playerModel:(LSPlayerModel *)playerModel {
    if(self = [super init]) {
        _lyricsArray = lyrics;
        self.playerModel = playerModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[LSLyricsTableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger selectedTimestamp = [self.lyricsArray[indexPath.section][@"time"][@"total"] floatValue] * 1000;
    [self.playerModel seek:selectedTimestamp];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *text = self.lyricsArray[indexPath.section][@"text"];
    cell.textLabel.text = [text length] == 0 ? @"♪" : text;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightHeavy];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // omit the last item because it's empty
    return [self.lyricsArray count] - 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)scrollToTop {
    NSIndexPath *top = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self.tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)updateTimestampForTime:(NSInteger)time {
    NSInteger initialTimestamp = [self.lyricsArray[0][@"time"][@"total"] floatValue] * 1000;
    if(time < initialTimestamp) {
        if([self.tableView indexPathForSelectedRow]) [self scrollToTop];
        return;
    }
    for(NSInteger i = 0; i < [self.lyricsArray count]; i++) {
        NSInteger next = [self.lyricsArray[i][@"time"][@"total"] floatValue] * 1000;
        if(next >= time) {
            NSIndexPath *currentSelectedIndexPath = [self.tableView indexPathForSelectedRow];
            if(currentSelectedIndexPath && [currentSelectedIndexPath section] == i - 1) return;
            if(i == 0) {
                [self scrollToTop];
                return;
            }
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:i - 1];
            [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            return;
        }
    }
    [self.tableView selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)reloadLyrics {
    [self.tableView reloadData];
    if([self.lyricsArray count] == 0) return;
    [self scrollToTop];
}

- (void)setPlayingTrack:(LSTrackItem *)track {
    [LSDataManager lyricsForSong:track.songName artist:track.artistName completion:^(NSArray *info) {
        self.lyricsArray = info;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadLyrics];
        });
    }];
}

@end
