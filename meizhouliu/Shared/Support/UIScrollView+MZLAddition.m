//
//  UIScrollView+MZLAddition.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-10-27.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIScrollView+MZLAddition.h"

@implementation UIScrollView (MZLAddition)

- (void)mzl_setInsetsForContentAndIndicator:(UIEdgeInsets)insets {
    self.contentInset = insets;
    self.scrollIndicatorInsets = insets;
}

@end
