//
//  UIScrollView+COAddition.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-12-11.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIScrollView+COAddition.h"

@implementation UIScrollView (COAddition)

- (CGFloat)co_bottomOffsetY {
    CGFloat contentHeight = self.contentSize.height;
    CGFloat boundsHeight = self.bounds.size.height;
    CGFloat insetBottom = self.contentInset.bottom;
    return contentHeight + insetBottom - boundsHeight;
}

- (BOOL)co_isScrollToBottom {
    return [self co_isScrollToBottomWithOffset:0];
}

- (BOOL)co_isScrollToBottomWithOffset:(CGFloat)offset {
    CGFloat offsetY = self.contentOffset.y;
    return offsetY >= [self co_bottomOffsetY] + offset;
}

@end
