//
//  UIButton+COAddition.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-12-29.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (COAddition)

@property (nonatomic) UIFont *titleFont;

- (void)co_setNormalBgColor:(UIColor *)normalBgColor;
- (void)co_setHighlightBgColor:(UIColor *)highlightBgColor;
- (void)co_setNormalBgColor:(UIColor *)normalBgColor highlightBgColor:(UIColor *)highlightBgColor;

- (void)co_setCornerRadius:(CGFloat)cornerRadius;

- (void)co_centerButtonAndImageWithSpacing:(CGFloat)spacing;

@end
