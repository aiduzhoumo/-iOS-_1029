//
//  UIViewController+MZLAdditions.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-16.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIViewController+MZLAdditions.h"
#import "UIView+MBProgressHUDAdditions.h"
#import "UIBarButtonItem+COAdditions.h"
#import "MobClick.h"
#import "JDStatusBarNotification.h"
#import "MZLSharedData.h"
#import "MZLLoginViewController.h"
#import "MZLSplashViewController.h"
#import "MZLModelUserLocationPref.h"
#import "MZLModelUserFavoredArticle.h"
#import "MZLLoginByMailViewController.h"

@implementation UIViewController (MZLAdditions)

- (void)showNetworkProgressIndicator {
    [self.view showProgressIndicator:MZL_MSG_LOADING message:nil];
}

- (void)showNetworkProgressIndicator:(NSString *)title {
    [self.view showProgressIndicator:title message:nil];
}

-(void) showWorkInProgressIndicator {
    [self.view showProgressIndicator:MZL_MSG_WORK_IN_PROGRESS message:nil];
}

-(void) showGetLocationProgressIndicatior{
    [self.view showProgressIndicator:MZL_MSG_GET_LOCATION_PROGRESS message:nil];
}

- (void) showUpLoadingProgressIndicator {
    [self.view showProgressIndicator:MZL_MSG_UPLOADING_PROGRESS message:nil];
}

- (void) hideProgressIndicator {
    [self hideProgressIndicator:YES];
}

- (void)hideProgressIndicator:(BOOL)flag {
    [self.view hideProgressIndicator:flag];
}

- (void)backToParent {
    if (self.tabBarController && self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
        [MobClick event:@"globalClickBackspace"];
        return;
    }
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIBarButtonItem *)backBarButtonItemWithImageNamed:(NSString *)name action:(SEL)action {
//    CGFloat size = 20.0;
//    FAKFontAwesome *backIcon = [FAKFontAwesome chevronLeftIconWithSize:size];
//    [backIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor]];
//    UIImage *backImage = [backIcon imageWithSize:CGSizeMake(size, size)];
    
//    UIImage *backImage = [UIImage imageNamed:@"BackArrow"];
//    if (action) {
//        return [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:action];
//    } else {
//        return [[UIBarButtonItem alloc]initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(backToParent)];
//    }
    
    SEL btnAction = action;
    if (! btnAction) {
        btnAction = @selector(backToParent);
    }
    return [UIBarButtonItem itemWithSize:CGSizeMake(24.0, 24.0) imageName:name  target:self action:btnAction];
}

- (void)onNetworkError {
    [self onNetworkError:nil];
}

- (void)onNetworkError:(NSError *)error {
    [self hideProgressIndicator];
    [UIAlertView alertOnNetworkError];
}

- (void)onDeleteError:(NSError *)error {
    [self hideProgressIndicator];
    [UIAlertView alertOnDeleteError];
}

- (void)onPostError:(NSError *)error {
    [self hideProgressIndicator];
    [UIAlertView alertOnConfigError];
}

- (BOOL)isTopViewControllerIfInNav {
    if (self.navigationController) {
        return self == self.navigationController.topViewController;
    }
    return NO;
}

#pragma mark - user favored location

- (void)showNotiTipOnFavoredLocStatusChanged:(MZLModelUserLocationPref *)userLocPref {
//    NSTimeInterval dismissInterval = MZL_JDSTATUSBAR_DISMISS_INTERVAL;
//    if (userLocPref) {
//        [JDStatusBarNotification showWithStatus:@"已添加想去" dismissAfter:dismissInterval styleName:MZL_JDSTATUSBAR_STYLE1];
//    } else {
//        [JDStatusBarNotification showWithStatus:@"已取消想去" dismissAfter:dismissInterval styleName:MZL_JDSTATUSBAR_STYLE1];
//    }
}

- (UIImage *)imageForFavoredLocation:(MZLModelUserLocationPref *)userLocPref {
    if (userLocPref.locationId) {
        return [UIImage imageNamed:@"Location_Interested"];
    } else {
        return [UIImage imageNamed:@"Location_Interest"];
    }
}

- (NSString *)imageNameForFavoredArticle:(MZLModelUserFavoredArticle *)userFavoredArticle {
    if (userFavoredArticle.articleId) {
        return @"tab_my_favor_sel";
    }
    return @"tab_my_favor";
}

#pragma mark - when to pop up login controller

- (void)popupLoginFrom:(NSInteger)from executionBlockWhenDismissed:(CO_BLOCK_VOID)executionBlockWhenDismissed {
    UIStoryboard *storyboard = MZL_MAIN_STORYBOARD();
    MZLLoginViewController * login = (MZLLoginViewController *) [storyboard instantiateViewControllerWithIdentifier:@"MZLLoginViewController"];
    login.popupFrom = from;
    login.executionBlockWhenDismissed = executionBlockWhenDismissed;
    [self presentViewController:login animated:YES completion:nil];
}

#pragma mark - when to pop up login controller

- (void)popupMailLoginFrom:(NSInteger)from executionBlockWhenDismissed:(CO_BLOCK_VOID)executionBlockWhenDismissed {
    UIStoryboard *storyboard = MZL_MAIN_STORYBOARD();
    MZLLoginByMailViewController * login = (MZLLoginByMailViewController *) [storyboard instantiateViewControllerWithIdentifier:@"MZLMailLoginViewController"];
    login.popupFrom = from;
    login.executionBlockWhenDismissed = executionBlockWhenDismissed;
    [self presentViewController:login animated:YES completion:nil];
}


#pragma mark - push view controller when notification arrives

- (void)mzl_pushViewController:(UIViewController *)vc {
    // 一般来说，所有的vc都由splashVc模态展示，除非该vc再被其它vc模态展示
    [UIAlertView showAlertMessage:NSStringFromClass([vc class])];
    if (! [self.presentingViewController isKindOfClass:[MZLSplashViewController class]]) {
        UIViewController *presentingVc = self.presentingViewController;
        __weak UINavigationController *navVc;
        if ([presentingVc isKindOfClass:[UITabBarController class]]) {
            navVc = (UINavigationController *)(((UITabBarController *)presentingVc).selectedViewController);
        } else if ([presentingVc isKindOfClass:[UINavigationController class]]) {
            navVc = (UINavigationController *)presentingVc;
        } else {
            navVc = presentingVc.navigationController;
        }
        [presentingVc dismissViewControllerAnimated:YES completion:^{
            [navVc pushViewController:vc animated:YES];
        }];
        return;
    }
        
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - active from background

- (void)mzl_viewControllerBecomeActiveFromBackground {
}

#pragma mark - switch child view controllers

/**
 *  切换child view controllers
 *
 *  @param toController
 *  @param parentView
 */
- (void)mzl_flipToChildViewController:(UIViewController *)toController inView:(UIView *)parentView {
    if (self.childViewControllers.count > 0) {
        //由于只保留一个child view controller，所以第一个即当前显示的child view controller
        [self mzl_flipFromViewController:self.childViewControllers[0] toViewController:toController inView:parentView];
    } else {
        [self mzl_flipFromViewController:nil toViewController:toController inView:parentView];
    }
}

- (void)mzl_flipFromViewController:(UIViewController *)fromController toViewController:(UIViewController *)toController inView:(UIView *)parentView {
    [self addChildViewController:toController];
    [fromController willMoveToParentViewController:nil];
    
    toController.view.frame = parentView.bounds;
    [parentView addSubview:toController.view];
    
    [fromController.view removeFromSuperview];
    [fromController removeFromParentViewController];
    
    [toController didMoveToParentViewController:self];
}

#pragma mark - tab bar controller visible controller

- (void)mzl_onWillBecomeTabVisibleController {
}

- (BOOL)mzl_canBecomeTabVisibleController {
    return YES;
}

@end
