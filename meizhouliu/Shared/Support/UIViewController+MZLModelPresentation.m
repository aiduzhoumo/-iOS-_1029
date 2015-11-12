//
//  UIViewController+MZLModelPresentation.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-4.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIViewController+MZLModelPresentation.h"

@implementation UIViewController (MZLModelPresentation) 

- (void)initWithStatusBar:(UIView *)statusBar navBar:(UINavigationBar *)navBar {
    [statusBar setBackgroundColor:MZL_NAVBAR_BG_COLOR()];
    [self initNavBar:navBar];
}

- (void)initNavBar:(UINavigationBar *)navBar {
    // 移除默认背景
    [navBar setBackgroundImage:nil forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    UINavigationItem *topItem = navBar.topItem;
    UINavigationItem *bottomItem = [[UINavigationItem alloc]init];
    bottomItem.title = @"取消";
    
    [navBar popNavigationItemAnimated:NO];
    [navBar pushNavigationItem:bottomItem animated:NO];
    [navBar pushNavigationItem:topItem animated:NO];
    
    navBar.delegate = self;
}

#pragma mark - navigation bar delegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

@end
