//
//  LSLyricsTableViewController.m
//  LyricsSearch
//
//  Created by Brandon Yao on 1/9/22.
//

#import "LSLyricsTableViewController.h"

@interface LSLyricsTableViewController ()
@property (nonatomic, assign) float nextTimestamp;
@property (nonatomic, assign) NSInteger nextSection;
@end

@implementation LSLyricsTableViewController

- (instancetype)initWithLyrics:(NSArray *)lyrics {
    if(self = [super init]) {
        _lyricsArray = lyrics;
        self.nextTimestamp = [self.lyricsArray[self.nextSection][@"time"][@"total"] floatValue] * 1000;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.nextSection = 0;
    if([self.lyricsArray count] == 0) return;
    NSIndexPath *top = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.nextSection = [indexPath section] + 1;
    self.nextTimestamp = [self.lyricsArray[self.nextSection][@"time"][@"total"] floatValue] * 1000;
    NSInteger selectedTimestamp = self.nextSection == 0 ? 0 : [self.lyricsArray[self.nextSection - 1][@"time"][@"total"] floatValue] * 1000;
    LSPlayerModel *sharedPlayer = [LSPlayerModel sharedPlayer];
    [sharedPlayer seek:selectedTimestamp];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *text = self.lyricsArray[indexPath.section][@"text"];
    cell.textLabel.text = [text length] == 0 ? @"..." : text;
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

- (void)updateElapsedTime:(NSInteger)elapsedTime {
    NSLog(@"%ld %ld", elapsedTime, (long) self.nextTimestamp);
    if(elapsedTime > self.nextTimestamp) {
        if(self.nextSection < [self.lyricsArray count] - 1) {
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.nextSection];
            [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            self.nextSection++;
            self.nextTimestamp = [self.lyricsArray[self.nextSection][@"time"][@"total"] floatValue] * 1000;
        }
        else [self.tableView selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}

- (void)setPlayingTrack:(LSTrackItem *)track {
    self.lyricsArray = [LSDataManager lyricsForSong:track.songName artist:track.artistName];
    [self.tableView reloadData];
    if([self.lyricsArray count] == 0) return;
    NSIndexPath *top = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
    self.nextSection = 0;
    self.nextTimestamp = [self.lyricsArray[self.nextSection][@"time"][@"total"] floatValue] * 1000;
}

@end
