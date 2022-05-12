// TODO: Keep playing song in background when viewcontroller closed
// TODO: Load more songs when scrolling to bottom
// TODO: Download next song's lyrics while current song playing
// TODO: Spotify integration
// TODO: Add option to modify queue manually
// TODO: Optimize downloading and maybe persistent cache

//
//  ViewController.m
//  LyricsSearch
//
//  Created by Brandon Yao on 1/9/22.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) LSMediaPlayerView *mediaPlayerView;
@property (nonatomic, strong) UIView *searchResultContainerView;
@property (nonatomic, strong) UIView *promptContainerView;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *queueButton;
@property (nonatomic, strong) LSSearchResultTableViewController *searchResultTableViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *searchIconImage = [UIImage imageNamed:@"SearchIcon"];
    UIImage *queueIconImage = [UIImage imageNamed:@"QueueIcon"];
    self.view.backgroundColor = [UIColor colorWithWhite:0.12f alpha:1.0f];
    self.mediaPlayerView = [[LSMediaPlayerView alloc] init];
    self.mediaPlayerView.backgroundColor = [UIColor blackColor];
    self.mediaPlayerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mediaPlayerView.layer.cornerRadius = 10;
    self.mediaPlayerView.layer.masksToBounds = YES;
    [self.view addSubview:self.mediaPlayerView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mediaPlayerTapped)];
    [self.mediaPlayerView addGestureRecognizer:tapGesture];
    [self.mediaPlayerView beginObserving];
    self.promptContainerView = [[UIView alloc] init];
    self.promptContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.promptContainerView];
    self.searchTextField = [[UITextField alloc] init];
    // have to use attributed string to make placeholder text black
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Song Name" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchTextField.textColor = [UIColor blackColor];
    self.searchTextField.backgroundColor = [UIColor whiteColor];
    self.searchTextField.layer.cornerRadius = 18;
    self.searchTextField.layer.masksToBounds = YES;
    self.searchTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.searchTextField addTarget:self action:@selector(presentSearchResults) forControlEvents:UIControlEventEditingDidEndOnExit];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 20)];
    self.searchTextField.leftView = paddingView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *searchContainerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,searchIconImage.size.width+15,searchIconImage.size.height)];
    self.searchTextField.rightView = searchContainerView;
    self.searchTextField.rightViewMode = UITextFieldViewModeAlways;
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,searchIconImage.size.width,searchIconImage.size.height)];
    [searchButton addTarget:self action:@selector(presentSearchResults) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setImage:searchIconImage forState:UIControlStateNormal];
    searchButton.translatesAutoresizingMaskIntoConstraints = NO;
    [searchContainerView addSubview:searchButton];
    [self.promptContainerView addSubview:self.searchTextField];
    self.searchResultContainerView = [[UIView alloc] init];
    self.searchResultContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:self.searchResultContainerView atIndex:0];
    self.queueButton = [[UIButton alloc] init];
    [self.queueButton setImage:queueIconImage forState:UIControlStateNormal];
    [self.queueButton addTarget:self action:@selector(presentQueue) forControlEvents:UIControlEventTouchUpInside];
    self.queueButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.queueButton];
    [NSLayoutConstraint activateConstraints:@[
        [self.mediaPlayerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-40],
        [self.mediaPlayerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.mediaPlayerView.widthAnchor constraintEqualToConstant:380],
        [self.mediaPlayerView.heightAnchor constraintEqualToConstant:60],
        [self.promptContainerView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.promptContainerView.bottomAnchor constraintEqualToAnchor:self.view.topAnchor constant:150],
        [self.promptContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.promptContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.searchResultContainerView.topAnchor constraintEqualToAnchor:self.promptContainerView.bottomAnchor],
        [self.searchResultContainerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.searchResultContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.searchResultContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.searchTextField.widthAnchor constraintEqualToConstant:300],
        [self.searchTextField.heightAnchor constraintEqualToConstant:40],
        [self.searchTextField.bottomAnchor constraintEqualToAnchor:self.promptContainerView.bottomAnchor constant:-10],
        [self.searchTextField.centerXAnchor constraintEqualToAnchor:self.promptContainerView.centerXAnchor constant:-20],
        [searchButton.topAnchor constraintEqualToAnchor:searchContainerView.topAnchor],
        [searchButton.leftAnchor constraintEqualToAnchor:searchContainerView.leftAnchor],
        [searchButton.bottomAnchor constraintEqualToAnchor:searchContainerView.bottomAnchor],
        [searchButton.rightAnchor constraintEqualToAnchor:searchContainerView.rightAnchor constant:-15],
        [self.queueButton.leadingAnchor constraintEqualToAnchor:self.searchTextField.trailingAnchor constant:10],
        [self.queueButton.centerYAnchor constraintEqualToAnchor:self.searchTextField.centerYAnchor],
        [self.queueButton.heightAnchor constraintEqualToConstant:30],
        [self.queueButton.widthAnchor constraintEqualToAnchor:self.queueButton.heightAnchor]
    ]];
}

- (void)mediaPlayerTapped {
    if([[LSPlayerModel sharedPlayer] currentItem]) {
        [self.searchResultTableViewController presentViewController:self.searchResultTableViewController.lyricsViewController animated:YES completion:nil];
    }
}

- (void)presentQueue {
    LSQueueTableViewController *queueTableViewController = [[LSQueueTableViewController alloc] init];
    [self presentViewController:queueTableViewController animated:YES completion:nil];
}

- (void)presentSearchResults {
    [self.searchTextField endEditing:YES];
    NSString *searchTerm = self.searchTextField.text;
    if(self.searchResultTableViewController) self.searchResultTableViewController.searchTerm = searchTerm;
    else {
        self.searchResultTableViewController = [[LSSearchResultTableViewController alloc] initWithSearchTerm:searchTerm];
        [self addChildViewController:self.searchResultTableViewController];
        [self.searchResultContainerView addSubview:self.searchResultTableViewController.view];
        self.searchResultTableViewController.view.frame = self.searchResultContainerView.bounds;
        [self.searchResultTableViewController didMoveToParentViewController:self];
    }
    [self.searchResultTableViewController loadNewPage];
}

@end
