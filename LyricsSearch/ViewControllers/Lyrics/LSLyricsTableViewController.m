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
@property (nonatomic, assign) float nextTimestamp;
@property (nonatomic, assign) NSInteger nextSection;
@property (nonatomic, assign) NSInteger previousTime;
@end

@implementation LSLyricsTableViewController

- (instancetype)initWithLyrics:(NSArray *)lyrics playerModel:(LSPlayerModel *)playerModel {
    if(self = [super init]) {
        _lyricsArray = lyrics;
        self.playerModel = playerModel;
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.tableView selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.nextSection = [indexPath section] + 1;
    self.nextTimestamp = [self.lyricsArray[self.nextSection][@"time"][@"total"] floatValue] * 1000;
    NSInteger selectedTimestamp = self.nextSection == 0 ? 0 : [self.lyricsArray[self.nextSection - 1][@"time"][@"total"] floatValue] * 1000;
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

- (void)updateTimestampForTime:(NSInteger)time {
    for(NSInteger i = 0; i < [self.lyricsArray count]; i++) {
        NSInteger next = [self.lyricsArray[i][@"time"][@"total"] floatValue] * 1000;
        if(next >= time) {
            if(i == self.nextSection) return;
            self.nextSection = i;
            self.nextTimestamp = next;
            if(i == 0) {
                NSIndexPath *top = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionTop];
                [self.tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
                return;
            }
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:i - 1];
            [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            return;
        }
    }
    self.nextSection = [self.lyricsArray count] - 1;
    [self.tableView selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)updateElapsedTime:(NSInteger)elapsedTime {
    // bad
    if([self.playerModel paused]) return;
    if(self.previousTime > elapsedTime) [self updateTimestampForTime:elapsedTime];
    else if(elapsedTime > self.nextTimestamp) {
        if(self.nextSection < [self.lyricsArray count] - 1) {
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.nextSection];
            [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            self.nextSection++;
            self.nextTimestamp = [self.lyricsArray[self.nextSection][@"time"][@"total"] floatValue] * 1000;
        }
        else [self.tableView selectRowAtIndexPath:nil animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    self.previousTime = elapsedTime;
}

- (void)reloadLyrics {
    [self.tableView reloadData];
    if([self.lyricsArray count] == 0) return;
    NSIndexPath *top = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
    self.nextSection = 0;
    self.nextTimestamp = [self.lyricsArray[self.nextSection][@"time"][@"total"] floatValue] * 1000;
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
