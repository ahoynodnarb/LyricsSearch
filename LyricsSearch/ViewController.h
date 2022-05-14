//
//  ViewController.h
//  LyricsSearch
//
//  Created by Brandon Yao on 1/9/


#import <UIKit/UIKit.h>
#import "LSMediaPlayerView.h"
#import "LSPlayerModel.h"
#import "LSTrackQueue.h"
#import "LSSearchResultTableViewController.h"
#import "LSQueueTableViewController.h"
#import <SpotifyiOS/SpotifyiOS.h>

@interface ViewController : UIViewController <SPTSessionManagerDelegate>
@property (nonatomic, strong) SPTAppRemote *appRemote;
@property (nonatomic, strong) SPTSessionManager *sessionManager;
@property (nonatomic, strong) SPTConfiguration *configuration;
@end

