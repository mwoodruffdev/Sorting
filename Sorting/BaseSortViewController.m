//
//  BaseSortViewController.m
//  Sorting
//
//  Created by Michael Woodruff on 29/10/2016.
//  Copyright © 2016 Mike Woodruff. All rights reserved.
//

#import "BaseSortViewController.h"

@implementation BaseSortViewController

- (void) sort {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end
