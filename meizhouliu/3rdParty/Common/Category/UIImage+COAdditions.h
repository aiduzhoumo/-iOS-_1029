//
//  UIImage+COAdditions.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-22.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (COAdditions)

#pragma mark - save

- (void)co_saveToSavedPhotoAlbum;

#pragma mark - screenshot

+ (UIImage *)windowScreenshot;
+ (UIImage *)co_screenshotFromView:(UIView *)view;
+ (UIImage *)co_screenshotFromLayer:(CALayer *)layer;

#pragma mark - apply filters

- (UIImage *)co_applyChromeFilter;
- (UIImage *)co_blurredImage:(CGFloat)radius;

#pragma mark - scale & crop related

- (UIImage *)co_cropInRect:(CGRect)rect;
/** 按宽度不超过maxWidth或高度不超过maxHeight等比缩放，widthHasPriority决定是先宽度还是先高度 */
- (UIImage *)co_resizeWithMaxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight widthHasPriority:(BOOL)flag;
//- (UIImage *)co_resizeWithMinDimension:(CGFloat)minDimension maxDimension:(CGFloat)maxDimension;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (UIImage *)scaledToSize:(CGSize)newSize;

#pragma mark - image from color

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

#pragma mark - combine images

+ (UIImage *)combineImagesWithContentImageCenter:(UIImage *)contentImage bgImage:(UIImage *)bgImage;
+ (UIImage *)combineImagesWithContentImageTopLeft:(UIImage *)contentImage bgImage:(UIImage *)bgImage;
+ (UIImage *)combineImagesWithBgImage:(UIImage *)bgImage contentImage:(UIImage *)contentImage contentImagePos:(CGPoint)position;

@end
