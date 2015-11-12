//
//  UIAlertView+COAdditions.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-8.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (COAdditions)

+ (void) showAlertMessage:(NSString *)message title:(NSString *)title cancleButtonTitle:(NSString *)cancelButtonTitle;

@end
