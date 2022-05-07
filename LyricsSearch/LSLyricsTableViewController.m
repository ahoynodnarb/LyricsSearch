//
//  LSLyricsTableViewController.m
//  LyricsSearch
//
//  Created by Brandon Yao on 1/9/22.
//

#import "LSLyricsTableViewController.h"

@interface LSLyricsTableViewController ()
@property (nonatomic, assign) float nextTimestamp;
@property (nonatomic, assign) float elapsedTime;
@property (nonatomic, assign) NSInteger nextSection;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LSLyricsTableViewController


- (instancetype)initWithLyrics:(NSArray *)lyrics trackDuration:(NSInteger)duration {
    if(self = [super init]) {
        self.lyricsArray = lyrics;
        self.duration = duration * 1000;
        self.playing = YES;
    }
    return self;
}

- (void)setPlaying:(BOOL)playing {
    _playing = playing;
    if(playing) {
        if(![self.timer isValid]) [self beginTimer];
    }
    else [self.timer invalidate];
}

- (void)timerFired {
    self.elapsedTime++;
    if(self.nextSection == [self.lyricsArray count] - 1) {
        [self.timer invalidate];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (self.duration - self.elapsedTime) * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"playNextTrack" object:nil];
        });
        return;
    }
    if(self.elapsedTime >= self.nextTimestamp) {
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.nextSection];
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        self.nextSection++;
        self.nextTimestamp = [self.lyricsArray[self.nextSection][@"time"][@"total"] floatValue] * 1000;
    }
}

- (void)beginTimer {
    NSLog(@"starting timer");
    if(self.timer || [self.timer isValid]) {
        [self.timer invalidate];
        NSLog(@"invalidating");
    }
    self.nextTimestamp = [self.lyricsArray[self.nextSection][@"time"][@"total"] floatValue] * 1000;
    self.timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[LSLyricsTableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)setPlayingTrack:(LSTrackItem *)track {
//    [self.timer invalidate];
    self.lyricsArray = [LSDataManager lyricsForSong:track.songName artist:track.artistName];
    self.duration = track.duration;
    self.nextSection = 0;
    [self.tableView reloadData];
    if([self.lyricsArray count] == 0) return;
    NSIndexPath *top = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self beginTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.playing = NO;
    self.nextSection = 0;
    if([self.lyricsArray count] == 0) return;
    NSIndexPath *top = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.nextSection = [indexPath section] + 1;
    self.nextTimestamp = [self.lyricsArray[self.nextSection][@"time"][@"total"] floatValue] * 1000;
    self.elapsedTime = self.nextSection == 0 ? 0 : [self.lyricsArray[self.nextSection - 1][@"time"][@"total"] floatValue] * 1000;
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

@end
