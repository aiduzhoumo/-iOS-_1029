//
//  NSString+MZLImageURL.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-3-5.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MZL_IMAGE_MODE_180_180 @"iphone.cut.300.300"
#define MZL_IMAGE_MODE_210_210 @"iphone.cut.210.210"
#define MZL_IMAGE_MODE_540_366 @"iphone.cut.540.366"
#define MZL_IMAGE_MODE_580_386 @"iphone.cut.580.386"
#define MZL_IMAGE_MODE_640_360 @"iphone.cut.640.360"
#define MZL_IMAGE_MODE_640_400 @"iphone.cut.640.400"
#define MZL_IMAGE_MODE_640_600 @"iphone.cut.640.600"
#define MZL_IMAGE_MODE_640_1008 @"iphone.cut.640.1008"
#define MZL_IMAGE_MODE_SCALED @"photo.scale.big"


@interface NSString (MZLImageURL)

- (NSString *)imageUrl_210_210;
- (NSString *)imageUrl_640_360;
- (NSString *)imageUrl_640_600;
- (NSString *)imageUrl_Scaled;

- (NSString *)imageUrlWithMode:(NSString *)mode;

@end
