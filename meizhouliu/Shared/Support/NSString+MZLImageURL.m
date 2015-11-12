//
//  NSString+MZLImageURL.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-3-5.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "NSString+MZLImageURL.h"

#define IMAGE_URL_PATTERN @"%@!%@"

@implementation NSString (MZLImageURL)

- (NSString *)imageUrl_210_210 {
    return [self imageUrlWithMode:MZL_IMAGE_MODE_210_210];
}

- (NSString *)imageUrl_640_360 {
    return [self imageUrlWithMode:MZL_IMAGE_MODE_640_360];
}

- (NSString *)imageUrl_640_600 {
    return [self imageUrlWithMode:MZL_IMAGE_MODE_640_600];
}

- (NSString *)imageUrl_Scaled {
    return [self imageUrlWithMode:MZL_IMAGE_MODE_SCALED];
}

/** 根据模式(尺寸定义)组装又拍上的图片URL */
- (NSString *)imageUrlWithMode:(NSString *)mode {
    NSString *result = self;
    if (! isEmptyString(mode)) {
        result = [NSString stringWithFormat:IMAGE_URL_PATTERN, result, mode];
    }
    return result;
}

@end
