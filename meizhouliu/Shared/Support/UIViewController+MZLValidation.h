//
//  UIViewController+MZLValidation.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-16.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MZLValidation)

- (BOOL)verifyNickName:(UITextField *)txt;
- (BOOL)verifyPassword:(UITextField *)txt;
- (BOOL)verifyEmail:(UITextField *)txt;
- (BOOL)verifyPhone:(UITextField *)phone;

@end
