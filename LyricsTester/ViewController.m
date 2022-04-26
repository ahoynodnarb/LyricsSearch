// TODO: Asynchronous/background downloading
// TODO: Refactor cell selection
// TODO: Add message in case no lyrics found (find better API?)
// TODO: Optimize downloading and maybe persistent cache

//
//  ViewController.m
//  LyricsTester
//
//  Created by Brandon Yao on 1/9/22.
//

#import "ViewController.h"
#import "LTDataManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self test];
    self.view.backgroundColor = [UIColor blackColor];
    UIImage *searchIconImage = [UIImage imageNamed:@"SearchIcon"];
    self.promptContainerView = [[UIView alloc] init];
    self.promptContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.promptContainerView];
    self.promptTextField = [[UITextField alloc] init];
    self.promptTextField.placeholder = @"Song Name";
    self.promptTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.promptTextField.textColor = [UIColor blackColor];
    self.promptTextField.backgroundColor = [UIColor whiteColor];
    self.promptTextField.layer.cornerRadius = 18;
    self.promptTextField.layer.masksToBounds = YES;
    self.promptTextField.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 20)];
    self.promptTextField.leftView = paddingView;
    self.promptTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *searchContainerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,searchIconImage.size.width+15,searchIconImage.size.height)];
    self.promptTextField.rightView = searchContainerView;
    self.promptTextField.rightViewMode = UITextFieldViewModeAlways;
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,searchIconImage.size.width,searchIconImage.size.height)];
    [searchButton addTarget:self action:@selector(presentSearchResults) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setImage:searchIconImage forState:UIControlStateNormal];
    searchButton.translatesAutoresizingMaskIntoConstraints = NO;
    [searchContainerView addSubview:searchButton];
    [self.promptContainerView addSubview:self.promptTextField];
    self.searchResultContainerView = [[UIView alloc] init];
    self.searchResultContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.searchResultContainerView];
    [NSLayoutConstraint activateConstraints:@[
        [self.promptContainerView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.promptContainerView.bottomAnchor constraintEqualToAnchor:self.view.topAnchor constant:150],
        [self.promptContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.promptContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.searchResultContainerView.topAnchor constraintEqualToAnchor:self.promptContainerView.bottomAnchor],
        [self.searchResultContainerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.searchResultContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.searchResultContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.promptTextField.widthAnchor constraintEqualToConstant:300],
        [self.promptTextField.heightAnchor constraintEqualToConstant:40],
        [self.promptTextField.bottomAnchor constraintEqualToAnchor:self.promptContainerView.bottomAnchor constant:-10],
        [self.promptTextField.centerXAnchor constraintEqualToAnchor:self.promptContainerView.centerXAnchor],
        [searchButton.topAnchor constraintEqualToAnchor:searchContainerView.topAnchor],
        [searchButton.leftAnchor constraintEqualToAnchor:searchContainerView.leftAnchor],
        [searchButton.bottomAnchor constraintEqualToAnchor:searchContainerView.bottomAnchor],
        [searchButton.rightAnchor constraintEqualToAnchor:searchContainerView.rightAnchor constant:-15],
    ]];
}

//- (void)test {
////    NSString *const token = [[[NSProcessInfo processInfo] environment] objectForKey:@"USER_TOKEN"];
////    NSString *const baseURL = [@"https://apic-desktop.musixmatch.com/ws/1.1/macro.subtitles.get?format=json&user_language=en&namespace=lyrics_synched&f_subtitle_length_max_deviation=1&subtitle_format=mxm&app_id=web-desktop-app-v1.0&usertoken=" stringByAppendingString:token];
////    NSInteger commonTrackID = [LTDataManager commonTrackIDForSong:song artist:artist];
////    NSString *URLString = [NSString stringWithFormat:@"%@&commontrack_id=%ld", baseURL, (long)commonTrackID];
////    NSString *URLString = @"https://apic-desktop.musixmatch.com/ws/1.1/macro.subtitles.get?format=json&user_language=en&namespace=lyrics_synched&f_subtitle_length_max_deviation=1&subtitle_format=mxm&app_id=web-desktop-app-v1.0&usertoken=201219dbdb0f6aaba1c774bd931d0e79a28024e28db027ae72955c&commontrack_id=75649419";
//    NSString *URLString = @"https://apic-desktop.musixmatch.com/ws/1.1/macro.subtitles.get?format=json&user_language=en&namespace=lyrics_synched&f_subtitle_length_max_deviation=1&subtitle_format=mxm&app_id=web-desktop-app-v1.0&usertoken=201219dbdb0f6aaba1c774bd931d0e79a28024e28db027ae72955c";
////    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSLog(@"%@", URLString);
//    NSURL *URL = [NSURL URLWithString:URLString];
//    NSData *data = [NSData dataWithContentsOfURL:URL];
////    if(!data) return nil;
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"%@", dict[@"message"][@"body"][@"macro_calls"][@"track.subtitles.get"][@"message"][@"body"][@"subtitle_list"][0][@"subtitle"][@"subtitle_body"]);
////    NSString *lyricsJSON = dict[@"message"][@"body"][@"macro_calls"][@"track.subtitles.get"][@"message"][@"body"][@"subtitle_list"][0][@"subtitle"][@"subtitle_body"];
////    NSData *lyricsData = [lyricsJSON dataUsingEncoding:NSUTF8StringEncoding];
////    return lyricsData ? [NSJSONSerialization JSONObjectWithData:lyricsData options:0 error:nil] : nil;
//}

- (void)presentSearchResults {
    NSString *search = self.promptTextField.text;
    NSArray *results = [LTDataManager infoForSearchTerm:search];
    if(self.searchResultTableViewController) {
        self.searchResultTableViewController.searchResults = results;
        [self.searchResultTableViewController.tableView reloadData];
        return;
    }
    self.searchResultTableViewController = [[LTSearchResultTableViewController alloc] initWithSearchResults:results];
    [self addChildViewController:self.searchResultTableViewController];
    [self.searchResultContainerView addSubview:self.searchResultTableViewController.view];
    self.searchResultTableViewController.view.frame = self.searchResultContainerView.bounds;
    [self.searchResultTableViewController didMoveToParentViewController:self];
}

@end
