//
//  UILabel+COAdditions.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-28.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (COAdditions)

/** this method should be invoked after text is set */
- (CGSize)textSizeForSingleLine;

/** these method should be invoked after text is set */
- (void)co_addLeadingImage:(UIImage *)image imageSize:(CGSize)imageSize spaceWidth:(CGFloat)width;
- (void)co_addLeadingImage:(UIImage *)image imageFrame:(CGRect)frame spaceWidthBetweenImageAndTexts:(CGFloat)spaceWidth;
- (UILabel *)co_setLineSpacing:(CGFloat)lineSpacing;


@end
