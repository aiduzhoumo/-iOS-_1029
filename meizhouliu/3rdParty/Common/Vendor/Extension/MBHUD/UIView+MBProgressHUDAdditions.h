//
//  UIView+MBProgressHUDAdditions.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MBProgressHUDAdditions)

- (void)showProgressIndicator:(NSString *)title message:(NSString *)message;
- (void)showProgressIndicator:(NSString *)title message:(NSString *)message isUseWindowForDisplay:(BOOL)flag;
- (void)hideProgressIndicator;
- (void)hideProgressIndicator:(BOOL)flag;

+ (BOOL)isProgressIndicatorVisible;
+ (void)hideProgressIndicator:(BOOL)flag;


@end
