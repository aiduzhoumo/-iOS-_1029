//
//  UIAlertView+MZLAdditions.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-8.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (MZLAdditions)

+ (void) showAlertMessage:(NSString *)message;
+ (void) showAlertMessage:(NSString *)message title:(NSString *)title;

+ (void) showChoiceMessage:(NSString *)message okBlock:(CO_BLOCK_VOID)okBlock;

+ (void) alertOnNetworkError;
+ (void) alertOnDeleteError;
+ (void) alertOnConfigError;

@end
