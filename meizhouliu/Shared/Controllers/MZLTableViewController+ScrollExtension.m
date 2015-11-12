//
//  MZLTableViewController+ScrollExtension.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-28.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLTableViewController+ScrollExtension.h"
#import "MZLTabBarViewController.h"

@implementation MZLTableViewController (ScrollExtension)

//// override
//- (void)trackYOnScroll:(UIScrollView *)scrollView {
//    if ([self shouldIgnoreScroll]) {
//        return;
//    }
//    [super trackYOnScroll:scrollView];
//}

- (BOOL)shouldIgnoreScroll {
    return YES;
}

//- (void)onScrollUp:(UIScrollView *)scrollView {
//    [self showNavBarAndTabBar:YES];
//}
//
//- (void)onScrollDown:(UIScrollView *)scrollView {
//    [self showNavBarAndTabBar:NO];
//}

@end
