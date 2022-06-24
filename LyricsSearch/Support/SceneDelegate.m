//
//  SceneDelegate.m
//  LyricsSearch
//
//  Created by Brandon Yao on 1/9/22.
//

#import "SceneDelegate.h"
#import "Constants.h"
#import "ViewController.h"
#import "LSPlayerModel.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
    ViewController *controller = (ViewController *)[self.window rootViewController];
    LSPlayerModel *playerModel = [controller playerModel];
    // bad
    BOOL __block initialSetup = NO;
    static dispatch_once_t t;
    dispatch_once(&t, ^{
        initialSetup = YES;
        [controller setupSpotify];
    });
    if(initialSetup) return;
    if([playerModel.appRemote.connectionParameters accessToken]) {
        [playerModel.appRemote connect];
        return;
    }
    if(![controller.sessionManager session]) {
        [controller presentAuthorization];
        return;
    }
    [playerModel resumeFiring];
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    ViewController *controller = (ViewController *)[self.window rootViewController];
    LSPlayerModel *playerModel = [controller playerModel];
    if([playerModel.appRemote.connectionParameters accessToken]) [playerModel.appRemote disconnect];
    else [playerModel pauseFiring];
}


@end
