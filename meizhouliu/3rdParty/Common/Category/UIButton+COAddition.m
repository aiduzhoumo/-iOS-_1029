//
//  UIButton+COAddition.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-12-29.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIButton+COAddition.h"
#import "UIImage+COAdditions.h"

@implementation UIButton (COAddition)

- (void)co_setHighlightBgColor:(UIColor *)highlightBgColor {
    [self setBackgroundImage:[UIImage imageWithColor:highlightBgColor] forState:UIControlStateHighlighted];
}

- (void)co_setNormalBgColor:(UIColor *)normalBgColor {
    [self setBackgroundImage:[UIImage imageWithColor:normalBgColor] forState:UIControlStateNormal];
}

- (void)co_setNormalBgColor:(UIColor *)normalBgColor highlightBgColor:(UIColor *)highlightBgColor {
    [self co_setNormalBgColor:normalBgColor];
    [self co_setHighlightBgColor:highlightBgColor];
}

- (void)co_setCornerRadius:(CGFloat)cornerRadius {
    // Given the corner radius might not be working if background is set, need to set clipsToBounds
    self.clipsToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

- (UIFont *)titleFont {
    return self.titleLabel.font;
}

- (void)setTitleFont:(UIFont *)titleFont {
    self.titleLabel.font = titleFont;
}

/**
 *  Please refer to http://stackoverflow.com/questions/4564621/aligning-text-and-image-on-uibutton-with-imageedgeinsets-and-titleedgeinsets
 *
 *  @param spacing - space between image and text
 */
- (void)co_centerButtonAndImageWithSpacing:(CGFloat)spacing {
    CGFloat insetAmount = spacing / 2.0;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -insetAmount, 0, insetAmount);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, -insetAmount);
    UIEdgeInsets contentEdgeInsets = self.contentEdgeInsets;
    contentEdgeInsets.left += insetAmount;
    contentEdgeInsets.right += insetAmount;
    self.contentEdgeInsets = contentEdgeInsets;
}

@end
