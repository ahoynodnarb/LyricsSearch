//
//  LTTableViewController.h
//  LyricsTester
//
//  Created by Brandon Yao on 1/9/22.
//

#import <UIKit/UIKit.h>

@interface LTLyricsTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *lyricsArray;
@property (nonatomic, strong) NSTimer *timer;
- (instancetype)initWithLyrics:(NSArray *)lyrics;
@end
