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
    NSString *access_token = @"14fqESqdMGlW4THQXt6HJnQZfk9O_6J9nFsX4OYJiTxaXJJAVGH0o4JCERehO3gg";
    name = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *searchTerm = [NSString stringWithFormat:@"https://api.genius.com/search?q=%@&access_token=%@", name, access_token];
    NSData *data = [Utils dataForURL:[NSURL URLWithString:searchTerm]];
    NSLog(@"%@", data);
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *response = [dict objectForKey:@"response"];
    NSMutableArray *info = [[NSMutableArray alloc] init];
    for(NSDictionary *hit in [response objectForKey:@"hits"]) {
        NSDictionary *result = [hit objectForKey:@"result"];
        NSString *artistNames = [result objectForKey:@"artist_names"];
        NSString *songName = [result objectForKey:@"title"];
        NSString *coverArtURL = [result objectForKey:@"song_art_image_url"];
        NSDictionary *dict = @{@"artistName":artistNames, @"songName":songName, @"coverArtURL":coverArtURL};
        [info addObject:dict];
    }
    return info;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", [self tracksForName:@"Better Now"]);
    self.lyricsViewController = [[LTLyricsViewController alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self presentViewController:self.lyricsViewController animated:YES completion:nil];
}

@end
