
//  ViewController.m
//  LyricsTester
//
//  Created by Brandon Yao on 1/9/22.
//

#import "LTTableViewController.h"

@interface LTTableViewController () {
    NSArray *_lyricsArray;
}
@property (nonatomic, strong) NSIndexPath *previouslySelectedPath;
+ (UIColor *)deselectedCellColor;
+ (UIColor *)selectedCellColor;
- (void)tableView:(UITableView *)tableView selectCellAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation LTTableViewController


+ (UIColor *)selectedCellColor {
    return [UIColor whiteColor];
}

+ (UIColor *)deselectedCellColor {
    return [UIColor colorWithWhite:1.0 alpha:0.5];
}

- (void)setLyricsArray:(NSArray *)lyrics {
    _lyricsArray = lyrics;
}

- (NSArray *)lyricsArray {
    return _lyricsArray;
}

- (instancetype)initWithLyrics:(NSArray *)lyrics {
    if(self = [super init]) {
        self.lyricsArray = lyrics;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateElapsedTime:) name:@"updateElapsedTime" object:nil];
}

- (void)tableView:(UITableView *)tableView selectCellAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(self.previouslySelectedPath != indexPath) {
        UITableViewCell *previouslySelectedCell = [tableView cellForRowAtIndexPath:self.previouslySelectedPath];
        previouslySelectedCell.textLabel.transform = CGAffineTransformMakeScale(0.8,0.8);
        previouslySelectedCell.textLabel.textColor = [self.class deselectedCellColor];
        self.previouslySelectedPath = indexPath;
        cell.textLabel.layer.anchorPoint = CGPointMake(0,0);
        cell.textLabel.layer.position = cell.textLabel.layer.frame.origin;
        cell.textLabel.textColor = [self.class selectedCellColor];
        [UIView animateWithDuration:0.4 animations:^(void){
            cell.textLabel.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }
    [UIView setAnimationsEnabled:NO];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [UIView setAnimationsEnabled:YES];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    self.previouslySelectedPath = indexPath;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[self.lyricsArray objectAtIndex:indexPath.section] objectForKey:@"lyrics"];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightHeavy];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.backgroundColor = UIColor.clearColor;
    if(indexPath == self.previouslySelectedPath) {
        cell.textLabel.transform = CGAffineTransformMakeScale(1, 1);
        cell.textLabel.textColor = [self.class selectedCellColor];
        self.previouslySelectedPath = indexPath;
    }
    else {
        cell.textLabel.transform = CGAffineTransformMakeScale(0.8,0.8);
        cell.textLabel.textColor = [self.class deselectedCellColor];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSUInteger count = self.lyricsArray.count;
    return count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
