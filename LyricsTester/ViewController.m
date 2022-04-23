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
    self.songSelectionContainerView = [[UIView alloc] init];
    self.songSelectionContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.songSelectionContainerView];
    [NSLayoutConstraint activateConstraints:@[
        [self.promptContainerView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.promptContainerView.bottomAnchor constraintEqualToAnchor:self.view.topAnchor constant:150],
        [self.promptContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.promptContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.songSelectionContainerView.topAnchor constraintEqualToAnchor:self.promptContainerView.bottomAnchor],
        [self.songSelectionContainerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.songSelectionContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.songSelectionContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
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

- (void)presentSearchResults {
    NSString *search = self.promptTextField.text;
    NSArray *results = [LTDataManager infoForTrack:search];
    if(self.searchResultTableViewController) {
        self.searchResultTableViewController.searchResults = results;
        [self.searchResultTableViewController.tableView reloadData];
        return;
    }
    self.searchResultTableViewController = [[LTSearchResultTableViewController alloc] initWithSearchResults:results];
    [self addChildViewController:self.searchResultTableViewController];
    [self.songSelectionContainerView addSubview:self.searchResultTableViewController.view];
    self.searchResultTableViewController.view.frame = self.songSelectionContainerView.bounds;
    [self.searchResultTableViewController didMoveToParentViewController:self];
}

@end
