//
//  UIViewController+ScrollToRefresh.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-7-12.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIViewController+ScrollToRefresh.h"

#define SCROLL_STATE_NORMAL 0
#define SCROLL_STATE_DRAGGING 1

#define SCROLL_STATE_BOTTOM_DRAGGING 10
#define SCROLL_STATE_BOTTOM_REFRESH_ON_RELEASE 11
#define SCROLL_STATE_BOTTOM_REFRESHING 12

#define SCROLL_STATE_CHANGE_MIN_DISTANCE 50.0

@implementation UIViewController (ScrollToRefresh)

#pragma mark - protected

- (BOOL)isCaptureScrollEvent {
    return NO;
}

- (NSInteger)scrollState {
    return -1;
}

- (void)setScrollState:(NSInteger)scrollState {
}

#pragma mark - scroll to fresh, footer view

- (void)onScrollScrollingOnBottom {}

- (void)onScrollRefreshOnReleaseOnBottom {}

- (void)onScrollRefreshOnBottom {}

- (void)onScrollStateReset {}

#pragma mark - scroll view delegate

- (void)mzl_scrollToRefresh_scrollViewDidScroll:(UIScrollView *)scrollView {
    if (! [self isCaptureScrollEvent]) {
        return;
    }
    CGFloat contentY = scrollView.contentOffset.y;
    //    NSLog(@"%f", [self scrollContentBottomY:scrollView] + SCROLL_STATE_CHANGE_MIN_DISTANCE);
    switch (self.scrollState) {
        case SCROLL_STATE_DRAGGING:
            if ([self isScrollToTheBottom:scrollView] && scrollView.isDragging) {
                self.scrollState = SCROLL_STATE_BOTTOM_DRAGGING;
            }
            break;
        case SCROLL_STATE_BOTTOM_DRAGGING:
            if (contentY >= [self scrollContentBottomRefreshY:scrollView] && scrollView.isDragging) {
                self.scrollState = SCROLL_STATE_BOTTOM_REFRESH_ON_RELEASE;
                [self onScrollRefreshOnReleaseOnBottom];
            }
            break;
        case SCROLL_STATE_BOTTOM_REFRESH_ON_RELEASE:
            if (contentY < [self scrollContentBottomRefreshY:scrollView]) {
                self.scrollState = SCROLL_STATE_BOTTOM_DRAGGING;
                [self onScrollScrollingOnBottom];
            }
            break;
        default:
            break;
    }
}

- (void)mzl_scrollToRefresh_scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (! [self isCaptureScrollEvent]) {
        return;
    }
    switch (self.scrollState) {
        case SCROLL_STATE_NORMAL:
            self.scrollState = SCROLL_STATE_DRAGGING;
            break;
        default:
            break;
    }
}

- (void)mzl_scrollToRefresh_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (! [self isCaptureScrollEvent]) {
        return;
    }
    switch (self.scrollState) {
        case SCROLL_STATE_DRAGGING:
        case SCROLL_STATE_BOTTOM_DRAGGING:
            [self resetScrollState];
            [self onScrollStateReset];
            break;
        case SCROLL_STATE_BOTTOM_REFRESH_ON_RELEASE:
            self.scrollState = SCROLL_STATE_BOTTOM_REFRESHING;
            [self onScrollRefreshOnBottom];
            break;
            
        default:
            break;
    }
}

#pragma mark - supported for scroll view delegate

- (CGFloat)scrollContentBottomRefreshY:(UIScrollView *)scrollView {
    return [self scrollContentBottomY:scrollView] + SCROLL_STATE_CHANGE_MIN_DISTANCE;
}

/** scroll的contentSize到达底部的起始位置 */
- (CGFloat)scrollContentBottomY:(UIScrollView *)scrollView {
    return scrollView.contentSize.height - scrollView.frame.size.height + scrollView.contentInset.bottom;
}

- (BOOL)isScrollToTheBottom:(UIScrollView *)scrollView {
    return scrollView.contentOffset.y >= [self scrollContentBottomY:scrollView];
}

- (void)resetScrollState {
    self.scrollState = SCROLL_STATE_NORMAL;
}

@end
