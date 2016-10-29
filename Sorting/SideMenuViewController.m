//
//  SideMenuViewController.m
//  Sorting
//
//  Created by Michael Woodruff on 29/10/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

#import "SideMenuViewController.h"

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Loaded");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger test =  [super tableView:tableView numberOfRowsInSection:section];
    NSLog(@"%zd", test);
    return test;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
