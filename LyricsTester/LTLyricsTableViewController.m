//
//  ViewController.m
//  LyricsTester
//
//  Created by Brandon Yao on 1/9/22.
//

#import "LTLyricsTableViewController.h"
#import "LTLyricsTableViewCell.h"

@interface LTLyricsTableViewController ()
@property (nonatomic, assign) NSInteger nextSection;
@end

@implementation LTLyricsTableViewController

- (instancetype)initWithLyrics:(NSArray *)lyrics {
    if(self = [super init]) {
        self.lyricsArray = lyrics;
    }
    return self;
}

- (void)updateTimer {
    if(self.nextSection == [self.lyricsArray count]) {
        [self.timer invalidate];
        return;
    }
    float nextDelay = [[[self.lyricsArray objectAtIndex:self.nextSection] objectForKey:@"timestamp"] floatValue] / 1000.0f;
    float currentDelay = [[[self.lyricsArray objectAtIndex:self.nextSection - 1] objectForKey:@"timestamp"] floatValue] / 1000.0f;
    float delay = nextDelay - currentDelay;
    self.timer.fireDate = [self.timer.fireDate dateByAddingTimeInterval:delay];
}

- (void)selectNextCell {
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.nextSection++];
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self updateTimer];
}

- (void)beginTimer {
    float delay = [[[self.lyricsArray objectAtIndex:self.nextSection] objectForKey:@"timestamp"] floatValue] / 1000.0f;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(selectNextCell) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[LTLyricsTableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.nextSection = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"view will appear");
    [self beginTimer];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.nextSection = [indexPath section] + 1;
    [self updateTimer];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[self.lyricsArray objectAtIndex:indexPath.section] objectForKey:@"words"];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightHeavy];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.backgroundColor = UIColor.clearColor;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.lyricsArray count];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
