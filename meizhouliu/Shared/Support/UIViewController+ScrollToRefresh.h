//
//  UIViewController+ScrollToRefresh.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-7-12.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ScrollToRefresh) <UIScrollViewDelegate>

- (BOOL)isCaptureScrollEvent;

- (void)resetScrollState;

// scroll to fresh, footer view
- (void)onScrollScrollingOnBottom;
- (void)onScrollRefreshOnReleaseOnBottom;
- (void)onScrollRefreshOnBottom;
- (void)onScrollStateReset;

// public methods
- (void)mzl_scrollToRefresh_scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)mzl_scrollToRefresh_scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)mzl_scrollToRefresh_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@property (nonatomic, assign) NSInteger scrollState;

@end
