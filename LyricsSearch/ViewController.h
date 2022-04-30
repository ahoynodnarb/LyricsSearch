//
//  ViewController.h
//  LyricsTester
//
//  Created by Brandon Yao on 1/9/


#import <UIKit/UIKit.h>
#import "LSLyricsViewController.h"
#import "LSSearchResultTableViewController.h"

@interface ViewController : UIViewController
@property (nonatomic, strong) UIView *searchResultContainerView;
@property (nonatomic, strong) UIView *promptContainerView;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) LSLyricsViewController *lyricsViewController;
@property (nonatomic, strong) LSSearchResultTableViewController *searchResultTableViewController;
@end

