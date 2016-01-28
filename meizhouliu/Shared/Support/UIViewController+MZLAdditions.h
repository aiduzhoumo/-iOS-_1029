//
//  UIViewController+MZLAdditions.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-16.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MZLModelUserLocationPref, MZLModelUserFavoredArticle;

@interface UIViewController (MZLAdditions)

- (void)showNetworkProgressIndicator;
- (void)showNetworkProgressIndicator:(NSString *)title;
- (void)showWorkInProgressIndicator;
- (void)showGetLocationProgressIndicatior;
- (void)showUpLoadingProgressIndicator;
- (void)hideProgressIndicator;
- (void)hideProgressIndicator:(BOOL)flag;

// back button for the left item of the navigation controller
- (UIBarButtonItem *)backBarButtonItemWithImageNamed:(NSString *)name action:(SEL)action;
- (void)backToParent;

- (void)onNetworkError;
- (void)onNetworkError:(NSError *)error;
- (void)onDeleteError:(NSError *)error;
- (void)onPostError:(NSError *)error;

- (void)showNotiTipOnFavoredLocStatusChanged:(MZLModelUserLocationPref *)userLocPref;
- (UIImage *)imageForFavoredLocation:(MZLModelUserLocationPref *)userLocPref;

- (NSString *)imageNameForFavoredArticle:(MZLModelUserFavoredArticle *)userFavoredArticle;

- (void)popupLoginFrom:(NSInteger)from executionBlockWhenDismissed:(CO_BLOCK_VOID)executionBlockWhenDismissed;
- (void)popupMailLoginFrom:(NSInteger)from executionBlockWhenDismissed:(CO_BLOCK_VOID)executionBlockWhenDismissed;

- (BOOL)isTopViewControllerIfInNav;

- (void)mzl_pushViewController:(UIViewController *)vc;
- (void)mzl_viewControllerBecomeActiveFromBackground;

- (void)mzl_flipToChildViewController:(UIViewController *)toController inView:(UIView *)parentView;

- (void)mzl_onWillBecomeTabVisibleController;
- (BOOL)mzl_canBecomeTabVisibleController;

@end
