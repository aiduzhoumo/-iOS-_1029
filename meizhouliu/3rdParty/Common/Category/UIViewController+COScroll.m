//
//  UIViewController+COScroll.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-25.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIViewController+COScroll.h"
#import "NSObject+COAssociation.h"

#define KEY_LAST_SCROLL_POS @"KEY_LAST_SCROLL_POS"

@implementation UIViewController (COScroll)

- (NSValue *)co_lastScrollPositionObject {
    return [self getProperty:KEY_LAST_SCROLL_POS];
}

- (void)co_clearLastScrollPositionObject {
    [self removeProperty:KEY_LAST_SCROLL_POS];
}

- (CGPoint)co_lastScrollPosition {
    NSValue *valuePos = [self getProperty:KEY_LAST_SCROLL_POS];
    if (valuePos) {
        return [valuePos CGPointValue];
    }
    return CGPointMake(0.0, 0.0);
}

- (void)co_setLastScrollPosition:(CGPoint)lastScrollPosition {
    [self setProperty:KEY_LAST_SCROLL_POS value:[NSValue valueWithCGPoint:lastScrollPosition]];
}

- (void)co_setLastY:(CGFloat)y {
    [self co_setLastScrollPosition:CGPointMake(0.0, y)];
}

- (void)co_onScrollUp:(UIScrollView *)scrollView {
}

- (void)co_onScrollDown:(UIScrollView *)scrollView {
}

- (void)co_trackYOnScrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.isDecelerating) {
//        [self clearLastScrollPositionObject];
//        return;
//    }
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat boundsHeight = scrollView.bounds.size.height;
    CGFloat insetTop = scrollView.contentInset.top;
    CGFloat insetBottom = scrollView.contentInset.bottom;
    // reach top or bottom
    if (offsetY <= - (insetTop) || offsetY + insetBottom >= contentHeight - boundsHeight) {
        [self co_clearLastScrollPositionObject];
        return;
    }
    if (! [self co_lastScrollPositionObject]) {
        [self co_setLastY:offsetY];
        return;
    }
    CGFloat lastY = self.co_lastScrollPosition.y;
    CGFloat distance = offsetY - lastY;
    [self co_setLastY:offsetY];
    if (distance > 0) {
        [self co_onScrollDown:scrollView];
    } else if (distance < 0) {
        [self co_onScrollUp:scrollView];
    }
    
//    CGFloat minDistance = [self minScrollDistance];
//    if (distance > minDistance) {
//        [self setLastY:offsetY];
//        [self onScrollDown:scrollView];
//    } else if (distance < - minDistance) {
//        [self setLastY:offsetY];
//        [self onScrollUp:scrollView];
//    }
}

@end
