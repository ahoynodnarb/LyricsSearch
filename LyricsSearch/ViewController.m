// TODO: Add message in case no lyrics found
// TODO: Optimize downloading and maybe persistent cache
// TODO: Add queue for songs (option button next to each cell
// TODO: Add play/pause skip/previous seek (maybe player at the top or bottom?)

//
//  ViewController.m
//  LyricsTester
//
//  Created by Brandon Yao on 1/9/22.
//

#import "ViewController.h"
#import "LSDataManager.h"

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
    self.searchTextField = [[UITextField alloc] init];
    // have to use attributed string to make placeholder text black
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Song Name" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
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
        [self.searchTextField.widthAnchor constraintEqualToConstant:300],
        [self.searchTextField.heightAnchor constraintEqualToConstant:40],
        [self.searchTextField.bottomAnchor constraintEqualToAnchor:self.promptContainerView.bottomAnchor constant:-10],
        [self.searchTextField.centerXAnchor constraintEqualToAnchor:self.promptContainerView.centerXAnchor],
        [searchButton.topAnchor constraintEqualToAnchor:searchContainerView.topAnchor],
        [searchButton.leftAnchor constraintEqualToAnchor:searchContainerView.leftAnchor],
        [searchButton.bottomAnchor constraintEqualToAnchor:searchContainerView.bottomAnchor],
        [searchButton.rightAnchor constraintEqualToAnchor:searchContainerView.rightAnchor constant:-15],
    ]];
}

- (void)presentSearchResults {
    [self.searchTextField endEditing:YES];
    NSString *search = self.searchTextField.text;
    if(self.searchResultTableViewController) {
        self.searchResultTableViewController.searchTerm = search;
        self.searchResultTableViewController.currentPage = 1;
        [self.searchResultTableViewController loadNextPage];
        [self.searchResultTableViewController.tableView reloadData];
        return;
    }
    self.searchResultTableViewController = [[LSSearchResultTableViewController alloc] initWithSearchTerm:search];
    [self addChildViewController:self.searchResultTableViewController];
    [self.searchResultContainerView addSubview:self.searchResultTableViewController.view];
    self.searchResultTableViewController.view.frame = self.searchResultContainerView.bounds;
    [self.searchResultTableViewController didMoveToParentViewController:self];
}

@end
