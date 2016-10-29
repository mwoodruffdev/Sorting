//
//  SideMenuViewController.m
//  Sorting
//
//  Created by Michael Woodruff on 29/10/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

#import "BubbleSortViewController.h"
#import "InsertionSortViewController.h"
#import "MergeSortViewController.h"
#import "QuickSortViewController.h"
#import "SideMenuViewController.h"

@interface SideMenuViewController ()

@property (nonatomic)  NSInteger selectedIndex;

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.selectedIndex = 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.row != self.selectedIndex) {
        
        self.selectedIndex = indexPath.row;
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    _selectedIndex = selectedIndex;
    
    UIViewController* selectedViewController = nil;
    
    switch(selectedIndex) {
        case 0:
            selectedViewController = [[BubbleSortViewController alloc] init];
            break;
        case 1:
            selectedViewController = [[QuickSortViewController alloc] init];
            break;
        case 2:
            selectedViewController = [[MergeSortViewController alloc] init];
            break;
        case 3:
            selectedViewController = [[InsertionSortViewController alloc] init];
            break;
    }
    
    [self.delegate didSelectViewController:selectedViewController];
}

@end
