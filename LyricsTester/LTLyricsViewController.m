//
//  ViewController.m
//  LyricsTester
//
//  Created by Brandon Yao on 1/9/22.
//

#import "LTLyricsViewController.h"
#import "Utils.h"

@interface LTLyricsViewController ()

@end

@implementation LTLyricsViewController
@synthesize tableViewController;
@synthesize songLabel;
@synthesize containerView;
@synthesize backgroundImageView;

- (NSDictionary *)getSongInfo {
    NSString *songArtist = @"Khalid";
    NSString *songName = @"Better";
    NSURL *imageURL = [NSURL URLWithString:@"https://i.scdn.co/image/ab67616d0000b27360624c0781fd787c9aa4699c"];
    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] initWithObjects:@[songArtist, songName, data] forKeys:@[@"songArtist", @"songName", @"songArtwork"]];
    NSString *URLString = [NSString stringWithFormat:@"https://api.textyl.co/api/lyrics?q=%@ %@", songName, songArtist];
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSData *responseData = [Utils dataForURL:URL];
    if(responseData) {
        NSArray *lyricsArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        [songInfo setObject:lyricsArray forKey:@"lyricsArray"];
    }
    return songInfo;
}

- (void)updateView {
    NSDictionary *info = [self getSongInfo];
    NSString *songName = [info objectForKey:@"songName"];
    NSString *songArtist = [info objectForKey:@"songArtist"];
    NSData *artworkImageData = [info objectForKey:@"songArtwork"];
    NSArray *lyricsArray = [info objectForKey:@"lyricsArray"];
    self.tableViewController.lyricsArray = lyricsArray;
    self.backgroundImageView.image = [UIImage imageWithData:artworkImageData];
    self.songLabel.text = songName;
    [self.songLabel sizeToFit];
    self.artistLabel.text = songArtist;
    [self.artistLabel sizeToFit];
    [self.tableViewController.tableView reloadData];
    [self.tableViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewController = [[LTTableViewController alloc] init];
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]];
    blurEffectView.frame = self.view.bounds;
    [self.backgroundImageView insertSubview:blurEffectView atIndex:0];
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = UIColor.clearColor;
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.songLabel = [[MarqueeLabel alloc] init];
    self.songLabel.marqueeType = MLLeftRight;
    self.songLabel.animationCurve = UIViewAnimationOptionCurveLinear;
    self.songLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightHeavy];
    self.songLabel.textColor = UIColor.whiteColor;
    self.songLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.artistLabel = [[MarqueeLabel alloc] init];
    self.artistLabel.marqueeType = MLLeftRight;
    self.artistLabel.animationCurve = UIViewAnimationOptionCurveLinear;
    self.artistLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightHeavy];
    self.artistLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.artistLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.songLabel];
    [self.view addSubview:self.artistLabel];
    [NSLayoutConstraint activateConstraints:@[
        [self.backgroundImageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.backgroundImageView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width],
        [self.backgroundImageView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor],
        [self.containerView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:150],
        [self.containerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.containerView.widthAnchor constraintEqualToConstant:self.view.bounds.size.width-50],
        [self.containerView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor constant:-150],
        [self.songLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:50],
        [self.songLabel.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:45],
        [self.songLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.artistLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:100],
        [self.artistLabel.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:45],
        [self.artistLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
    [self displayContentController:self.tableViewController];
    [self updateView];
}

- (void)displayContentController:(UIViewController *)content;
{
    [self addChildViewController:content];
    [self.containerView addSubview:content.view];
    content.view.frame = self.containerView.bounds;
    [content didMoveToParentViewController:self];
}

@end
