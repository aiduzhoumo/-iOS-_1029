//
//  UIScrollView+COAddition.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-12-11.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (COAddition)

- (BOOL)co_isScrollToBottom;
- (BOOL)co_isScrollToBottomWithOffset:(CGFloat)offset;

@end
