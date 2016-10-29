//
//  SideMenuViewController.h
//  Sorting
//
//  Created by Michael Woodruff on 29/10/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol SideMenuViewControllerDelegate <NSObject>

@required
- (void)didSelectViewController:(UIViewController *)viewController;

@end

@interface SideMenuViewController : UITableViewController

@property (weak, nonatomic) id<SideMenuViewControllerDelegate> delegate;

@end


