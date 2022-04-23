//
//  ViewController.h
//  LyricsTester
//
//  Created by Brandon Yao on 1/9/


#import <UIKit/UIKit.h>
#import "LTLyricsViewController.h"
#import "LTSearchResultTableViewController.h"

@interface ViewController : UIViewController
@property (nonatomic, strong) UIView *searchResultContainerView;
@property (nonatomic, strong) UIView *promptContainerView;
@property (nonatomic, strong) UITextField *promptTextField;
@property (nonatomic, strong) LTLyricsViewController *lyricsViewController;
@property (nonatomic, strong) LTSearchResultTableViewController *searchResultTableViewController;
@end

