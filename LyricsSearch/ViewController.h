//
//  ViewController.h
//  LyricsSearch
//
//  Created by Brandon Yao on 1/9/


#import <UIKit/UIKit.h>
#import <SpotifyiOS/SpotifyiOS.h>
#import "LSLyricsViewController.h"
#import "LSMediaPlayerView.h"
#import "LSPlayerModel.h"
#import "LSQueueTableViewController.h"
#import "LSSearchResultTableViewController.h"
#import "LSTrackItem.h"
#import "LSTrackPresenter.h"
#import "LSTrackQueue.h"

@interface ViewController : UIViewController <SPTSessionManagerDelegate, LSTrackPresenter>
@property (nonatomic, strong) SPTSessionManager *sessionManager;
@property (nonatomic, strong) SPTConfiguration *configuration;
@property (nonatomic, strong) LSPlayerModel *playerModel;
@property (nonatomic, strong) LSMediaPlayerView *mediaPlayerView;
@property (nonatomic, strong) UIView *searchResultContainerView;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *queueButton;
@property (nonatomic, strong) LSSearchResultTableViewController *searchResultTableViewController;
@property (nonatomic, strong) LSLyricsViewController *lyricsViewController;
@end

