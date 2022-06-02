//
//  LSQueueTableViewController.m
//  LyricsSearch
//
//  Created by Brandon Yao on 5/8/22.
//

#import "LSQueueTableViewController.h"
#import "LSQueueTableViewCell.h"

@interface LSQueueTableViewController ()
@end

@implementation LSQueueTableViewController

- (instancetype)initWithPlayerModel:(LSPlayerModel *)playerModel {
    if(self = [super init]) {
        self.playerModel = playerModel;
    }
    return self;
}

- (NSArray *)displayedTracks {
    NSMutableArray *tracks = [self.nextTracks mutableCopy];
    if(self.playerModel.currentItem) [tracks insertObject:self.playerModel.currentItem atIndex:0];
    return [NSArray arrayWithArray:tracks];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextTracks = self.playerModel.nextTracks ? [self.playerModel.nextTracks mutableCopy] : [NSMutableArray array];
    self.tableView.editing = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(30.0f, 0.0f, 0.0f, 0.0f);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView registerClass:[LSQueueTableViewCell class] forCellReuseIdentifier:@"NextTrack"];
    [self.tableView registerClass:[LSQueueTableViewCell class] forCellReuseIdentifier:@"CurrentTrack"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.playerModel nextTracks] count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    LSQueueTableViewCell *cell = (LSQueueTableViewCell  *)recognizer.view;
    [cell animatePan:recognizer completion:^(BOOL success) {
        if(!success) return;
        NSInteger index = [[self.tableView indexPathForCell:cell] section];
        [self.playerModel removeTrackAtIndex:[self.playerModel currentTrackPosition] + index];
        [self.tableView reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = [indexPath section];
    NSString *reuseIdentifier = section == 0 ? @"CurrentTrack" : @"NextTrack";
    LSQueueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(section != 0) {
        LSTrackItem *item = self.nextTracks[section - 1];
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        recognizer.delegate = cell;
        [cell addGestureRecognizer:recognizer];
        cell.artist = item.artistName;
        cell.song = item.songName;
        cell.artwork = item.artImage;
    }
    else if ([self.playerModel currentItem]) {
        LSTrackItem *item = [self.playerModel currentItem];
        cell.artist = item.artistName;
        cell.song = item.songName;
        cell.artwork = item.artImage;
    }
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    if ([proposedDestinationIndexPath section] == 0) {
        return [NSIndexPath indexPathForRow:0 inSection:1];
    }
    return proposedDestinationIndexPath;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return [indexPath section] != 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSInteger sourceIndex = [sourceIndexPath section];
    NSInteger toIndex = [destinationIndexPath section];
    [self.playerModel moveTrackAtIndex:sourceIndex + [self.playerModel currentTrackPosition] toIndex:toIndex + [self.playerModel currentTrackPosition]];
}

@end
