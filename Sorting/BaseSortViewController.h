//
//  BaseSortViewController.h
//  Sorting
//
//  Created by Michael Woodruff on 29/10/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SortingViewController <NSObject>

@required
- (void)sort;

@end

@interface BaseSortViewController : UIViewController <SortingViewController>

@end
