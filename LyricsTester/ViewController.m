//
//  ViewController.m
//  LyricsTester
//
//  Created by Brandon Yao on 1/9/22.
//

#import "ViewController.h"
#import "Utils.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize lyricsViewController;

- (NSArray *)tracksForName:(NSString *)name {
    name = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSDictionary *headers = [[NSDictionary alloc] initWithObjects:@[@"application/json", @"application/json", @"Bearer BQDgCHQnLMpB7GcY7_kY2pqft1KEXAlhCR7hxF8gNSv7IZjzrpUdRGfPvPHL1p_zRDqqAbTPSIcl-xLjhNptb8CkrWgAbiLQqKgob2miqtLUbdpG4mksuIPbN7mehdBDzI_f-qcQBGuel7gN5RE"] forKeys:@[@"Accept", @"Content-Type", @"Authorization"]];
    NSString *searchTerm = [NSString stringWithFormat:@"https://api.spotify.com/v1/search?q=track%%3A%@&type=track&limit=10", name];
    NSData *data = [Utils dataForURL:[NSURL URLWithString:searchTerm] headers:headers];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary *tracks = [dict objectForKey:@"tracks"];
    NSMutableArray *info = [[NSMutableArray alloc] init];
    for(NSDictionary *item in [tracks objectForKey:@"items"]) {
        BOOL explicit = [[item objectForKey:@"explicit"] boolValue];
        NSString *trackName = [item objectForKey:@"name"];
        NSDictionary *album = [item objectForKey:@"album"];
        NSURL *coverArtURL = [NSURL URLWithString:[[[album objectForKey:@"images"] objectAtIndex:0] objectForKey:@"url"]];
        NSMutableArray *artists = [[NSMutableArray alloc] init];
        for(NSDictionary *artist in [item objectForKey:@"artists"]) {
            [artists addObject:[artist objectForKey:@"name"]];
        }
        [info addObject:@{@"explicit": @(explicit), @"trackName":trackName, @"coverArtURL":coverArtURL, @"artists":artists}];
        NSLog(@"%@ %@", coverArtURL, artists);
    }
    return info;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", [self tracksForName:@"Better Now"]);
    self.lyricsViewController = [[LTViewController alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self presentViewController:self.lyricsViewController animated:YES completion:nil];
}

@end
