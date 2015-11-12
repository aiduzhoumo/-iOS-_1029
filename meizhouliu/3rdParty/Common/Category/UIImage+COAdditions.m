//
//  UIImage+COAdditions.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-22.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIImage+COAdditions.h"

@implementation UIImage (COAdditions)

#pragma mark - screenshot

+ (UIImage *)windowScreenshot {
    UIImage *image = [self co_screenshotFromView:globalWindow()];
    return image;
}

+ (UIImage *)co_screenshotFromView:(UIView *)view {
    CGRect drawingRect = view.bounds;
    UIGraphicsBeginImageContextWithOptions(drawingRect.size, NO, [UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:drawingRect afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    if (! CGRectIsEmpty(rect)) {
//        image = [image co_cropInRect:rect];
//    }
    
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存图片到照片库
    return image;
}

+ (UIImage *)co_screenshotFromLayer:(CALayer *)layer {
    CGRect drawingRect = layer.bounds;
    UIGraphicsBeginImageContextWithOptions(drawingRect.size, NO, [UIScreen mainScreen].scale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - scale & crop related

/**
 *  对指定图片剪裁一块区域出来形成一张新的图片
 *
 *  @param rect 剪裁区域
 *
 *  @return UIImage *
 */
- (UIImage *)co_cropInRect:(CGRect)rect {
    if (CGPointEqualToPoint(CGPointZero, rect.origin) && CGSizeEqualToSize(rect.size, self.size)) {
        return self;
    }
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        // for retina-display
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    } else {
        // non-retina-display
        UIGraphicsBeginImageContext(rect.size);
    }
    [self drawAtPoint:(CGPoint){-rect.origin.x, -rect.origin.y}];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}

/**
 *  This method takes an image and a max dimension. If the max original image dimension is less than the specified max dimension, you get the original back so it won't get blown up. Otherwise, you get a new image having a max dimension of the one specified and the other determined by the original aspect ratio. So as an example, if you give it a 1024x768 image and max dimension of 640 you get back a 640x480 version, if you give it a 768x1024 image and max dimension of 640 you get back a 480x640 version - from stackoverflow
 *
 *  @param maxDimension - defined max dimension
 *
 *  @return - resized image
 */
- (UIImage *)co_resizeWithMaxDimension:(CGFloat)maxDimension {
    CGSize newSize = [self co_scaledSizeWithMaxDimension:maxDimension];
    return [self scaledToSize:newSize];
}

- (CGSize)co_scaledSizeWithMaxDimension:(CGFloat)maxDimension {
    if (fmax(self.size.width, self.size.height) <= maxDimension) {
        return CGSizeMake(self.size.width, self.size.height);
    }
    
    CGFloat aspect = self.size.width / self.size.height;
    CGSize newSize;
    
    if (self.size.width > self.size.height) {
        newSize = CGSizeMake(maxDimension, maxDimension / aspect);
    } else {
        newSize = CGSizeMake(maxDimension * aspect, maxDimension);
    }

    return newSize;
}

- (UIImage *)co_resizeWithMinDimension:(CGFloat)minDimension maxDimension:(CGFloat)maxDimension {
    CGSize newSize = [self co_scaledSizeWithMinDimension:minDimension maxDimension:maxDimension];
    return [self scaledToSize:newSize];
}

- (CGSize)co_scaledSizeWithMinDimension:(CGFloat)minDimension maxDimension:(CGFloat)maxDimension {
    // 由于图片的width是按像素计算，需要做处理
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGFloat width = floorf(self.size.width / screenScale);
    CGFloat height = floorf(self.size.height / screenScale);
    // 如果width或heigh一方为0，说明图片异常，原尺寸返回
    if (width == 0 || height == 0) {
        return CGSizeMake(width, height);
    }
    CGFloat aspect = width / height;
    CGSize newSize = CGSizeMake(width, height);
    // 规则，如果最短边>minDimension，按最短边=minDimension依比例缩放，
    // 否则如果长边>maxDimension，按最长边＝maxDimension依比例缩放
    if (width > height) {
        if (height > minDimension) {
            newSize = CGSizeMake(floorf(minDimension * aspect), minDimension);
        } else if (width > maxDimension) {
            newSize = CGSizeMake(maxDimension, floorf(maxDimension / aspect));
        }
    } else {
        if (width > minDimension) {
            newSize = CGSizeMake(minDimension, floorf(minDimension / aspect));
        } else if (height > maxDimension) {
            newSize = CGSizeMake(floorf(maxDimension * aspect), maxDimension);
        }
    }
    return newSize;
}

- (UIImage *)co_resizeWithMaxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight widthHasPriority:(BOOL)flag {
    CGSize newSize = [self co_scaledSizeWithMaxWidth:maxWidth maxHeight:maxHeight widthHasPriority:flag];
    return [self scaledToSize:newSize];
}

- (CGSize)co_scaledSizeWithMaxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight widthHasPriority:(BOOL)flag {
    // 由于图片的width是按像素计算，需要做处理
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGFloat width = floorf(self.size.width / screenScale);
    CGFloat height = floorf(self.size.height / screenScale);
    // 如果width或heigh一方为0，说明图片异常，原尺寸返回
    if (width == 0 || height == 0) {
        return CGSizeMake(width, height);
    }
    CGFloat aspect = width / height;
    CGSize newSize = CGSizeMake(width, height);
    if (flag) {
        if (width > maxWidth) {
            newSize = CGSizeMake(maxWidth, floorf(maxWidth / aspect));
        } else if (height > maxHeight) {
            newSize = CGSizeMake(floorf(maxHeight * aspect), maxHeight);
        }
    } else {
        if (height > maxHeight) {
            newSize = CGSizeMake(floorf(maxHeight * aspect), maxHeight);
        } else if (width > maxWidth) {
            newSize = CGSizeMake(maxWidth, floorf(maxWidth / aspect));
        }
    }
    return newSize;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)scaledToSize:(CGSize)newSize {
    return [UIImage imageWithImage:self scaledToSize:newSize];
}

//#pragma mark - image metadata
//
//- (CGFloat)co_getImageWidth {
//    return CGImageGetWidth(self.CGImage);
//}
//
//- (CGFloat)co_getImageHeight {
//    return CGImageGetHeight(self.CGImage);
//}

#pragma mark - apply filters 

- (UIImage *)co_applyChromeFilter {
    return [self co_applyFilterWithName:@"CIPhotoEffectChrome"];
}

- (UIImage *)co_applyFilterWithName:(NSString *)filterName {
    CIImage *ciImage = [[CIImage alloc] initWithImage:self];
    CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return result;
}

- (UIImage *)co_blurredImage:(CGFloat)radius {
    //  Create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    
    //  Setting up Gaussian Blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
     *  up exactly to the bounds of our original image */
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *retVal = [UIImage imageWithCGImage:cgImage];
    return retVal;
}

#pragma mark - save

- (void)co_saveToSavedPhotoAlbum {
    UIImageWriteToSavedPhotosAlbum(self, nil, nil, nil); //保存图片到照片库
}

#pragma mark - image from color

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1.0, 1.0)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - combine images

+ (UIImage *)combineImagesWithContentImageTopLeft:(UIImage *)contentImage bgImage:(UIImage *)bgImage {
    return [self combineImagesWithBgImage:bgImage contentImage:contentImage contentImagePos:CGPointMake(0, 0)];
}

+ (UIImage *)combineImagesWithContentImageCenter:(UIImage *)contentImage bgImage:(UIImage *)bgImage {
    CGPoint pos = CGPointMake((bgImage.size.width - contentImage.size.width) / 2.0 , (bgImage.size.height - contentImage.size.height) /2.0);
    return [self combineImagesWithBgImage:bgImage contentImage:contentImage contentImagePos:pos];
}

+ (UIImage *)combineImagesWithBgImage:(UIImage *)bgImage contentImage:(UIImage *)contentImage contentImagePos:(CGPoint)position {
    CGSize newSize = CGSizeMake(bgImage.size.width, bgImage.size.height);
    UIGraphicsBeginImageContext( newSize );
    
    // Use existing opacity as is
    [bgImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    // Apply supplied opacity if applicable
    [contentImage drawInRect:CGRectMake(position.x, position.y, contentImage.size.width, contentImage.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
