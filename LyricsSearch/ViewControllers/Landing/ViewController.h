//
//  ViewController.h
//  LyricsSearch
//
//  Created by Brandon Yao on 1/9/


#import <UIKit/UIKit.h>
#import "LSPlayerModel.h"
#import "LSTrackPresenter.h"
#import "LSPlayerDelegate.h"

@interface ViewController : UIViewController <SPTSessionManagerDelegate, LSTrackPresenter, LSPlayerDelegate>
@property (nonatomic, strong) SPTSessionManager *sessionManager;
@property (nonatomic, strong) SPTConfiguration *configuration;
@property (nonatomic, strong) LSPlayerModel *playerModel;
- (void)presentAuthorization;
- (void)setupSpotify;
@end

