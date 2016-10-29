//
//  ViewController.m
//  Sorting
//
//  Created by Michael Woodruff on 29/10/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

#import "BubbleSortViewController.h"
#import "SideMenuViewController.h"
#import "MainViewController.h"
#import <MFSideMenu/MFSideMenu.h>

@interface MainViewController ()

@property (strong, nonatomic) MFSideMenuContainerViewController*  containerController;
@property (strong, nonatomic) UIViewController* selectedViewController;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SideMenuViewController *sideMenuViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SideMenuViewController"];
    sideMenuViewController.delegate = self;
    
    self.containerController = [MFSideMenuContainerViewController containerWithCenterViewController:self.selectedViewController leftMenuViewController:sideMenuViewController rightMenuViewController:nil];

    
    [self addChildViewController:self.containerController];
    self.containerController.view.frame = self.view.frame;
    [self.view addSubview:self.containerController.view];
    [self.containerController didMoveToParentViewController:self];
}

- (void)didSelectViewController:(UIViewController *)viewController {
  
    self.selectedViewController = viewController;
    self.containerController.centerViewController = self.selectedViewController;
}

@end
