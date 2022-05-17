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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dragDelegate = self;
    self.tableView.dragInteractionEnabled = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(30.0f, 0.0f, 0.0f, 0.0f);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView registerClass:[LSQueueTableViewCell class] forCellReuseIdentifier:@"NextTrack"];
    [self.tableView registerClass:[LSQueueTableViewCell class] forCellReuseIdentifier:@"CurrentTrack"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.playerModel.nextTracks count] + (self.playerModel.currentItem != nil);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSArray *)getTracks {
    NSMutableArray *allTracks = self.playerModel.nextTracks ? [self.playerModel.nextTracks mutableCopy] : [NSMutableArray array];
    if(self.playerModel.currentItem) [allTracks insertObject:self.playerModel.currentItem atIndex:0];
    return allTracks;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = [indexPath section];
    NSArray *allTracks = [self getTracks];
    LSTrackItem *item = allTracks[section];
    LSQueueTableViewCell *cell;
    if(section == 0 && self.playerModel.currentItem) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CurrentTrack" forIndexPath:indexPath];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NextTrack" forIndexPath:indexPath];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.artist = item.artistName;
    cell.song = item.songName;
    cell.artwork = item.artImage;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// WIP
- (nonnull NSArray<UIDragItem *> *)tableView:(nonnull UITableView *)tableView itemsForBeginningDragSession:(nonnull id<UIDragSession>)session atIndexPath:(nonnull NSIndexPath *)indexPath {
    return [NSArray array];
}

@end
