//
//  ViewController.m
//  LyricsTester
//
//  Created by Brandon Yao on 1/9/22.
//

#import "LSLyricsTableViewController.h"

@interface LSLyricsTableViewController ()
@property (nonatomic, assign) NSInteger nextSection;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LSLyricsTableViewController

- (instancetype)initWithLyrics:(NSArray *)lyrics trackDuration:(NSInteger)duration {
    if(self = [super init]) {
        self.lyricsArray = lyrics;
        self.duration = duration;
    }
    return self;
}

- (void)updateTimer {
    float nextDelay = [self.lyricsArray[self.nextSection][@"time"][@"total"] floatValue];
    float currentDelay = [self.lyricsArray[self.nextSection - 1][@"time"][@"total"] floatValue];
    float delay = nextDelay - currentDelay;
    self.timer.fireDate = [self.timer.fireDate dateByAddingTimeInterval:delay];
}

- (void)selectNextCell {
    if(self.nextSection == [self.lyricsArray count]) {
        [self.timer invalidate];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"trackEnded" object:nil];
        return;
    }
    if(self.nextSection == [self.lyricsArray count] - 1) {
        float current = [self.lyricsArray[self.nextSection - 1][@"time"][@"total"] floatValue];
        float delay = self.duration - current;
        self.timer.fireDate = [self.timer.fireDate dateByAddingTimeInterval:delay];
        self.nextSection++;
        return;
    }
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.nextSection++];
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self updateTimer];
}

- (void)beginTimer {
    float delay = [self.lyricsArray[self.nextSection][@"time"][@"total"] floatValue];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(selectNextCell) userInfo:nil repeats:YES];
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

- (void)trackChanged {
    self.nextSection = 0;
    NSIndexPath *top = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self beginTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.nextSection = 0;
    NSIndexPath *top = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.lyricsArray) [self beginTimer];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.nextSection = [indexPath section] + 1;
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self updateTimer];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *text = self.lyricsArray[indexPath.section][@"text"];
    cell.textLabel.text = [text length] == 0 ? @"..." : text;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightHeavy];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.backgroundColor = [UIColor clearColor];
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
