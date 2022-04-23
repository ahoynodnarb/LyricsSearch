//
//  LTTableViewController.h
//  LyricsTester
//
//  Created by Brandon Yao on 1/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTLyricsTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *lyricsArray;
- (instancetype)initWithLyrics:(NSArray *)lyrics;
@end

NS_ASSUME_NONNULL_END
