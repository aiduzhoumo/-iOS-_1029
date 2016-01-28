//
//  UIViewController+MZLValidation.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-16.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIViewController+MZLValidation.h"
#import "NSString+COValidation.h"

@implementation UIViewController (MZLValidation)

#pragma mark - verify nick name

- (BOOL)verifyNickName:(UITextField *)txt {
    NSInteger strLen = [txt.text lengthUsingCustomRule];
    BOOL isValidLen = strLen >=4 && strLen <= 30;
    if (! isValidLen) {
        [UIAlertView showAlertMessage:@"昵称长度为4-30个字符（2-15个汉字）哦!"];
        return NO;
    }
    if (! [self isValidNickname:txt.text]) {
        [UIAlertView showAlertMessage:@"昵称只支持中英文和数字哦!"];
        return NO;
    }
    return YES;
}

- (BOOL)isValidNickname:(NSString *)str {
    return [str isValidViaRegExp:@"^[\u4e00-\u9fa5_a-zA-Z0-9]+$"];
}

#pragma mark - verify password

- (BOOL)verifyPassword:(UITextField *)txt {
    NSInteger strLen = [txt.text lengthUsingCustomRule];
    if (strLen < 6) {
        [UIAlertView showAlertMessage:@"密码长度最少6个字符哦!"];
        return NO;
    } else if (strLen > 255) {
        [UIAlertView showAlertMessage:@"密码长度最多255个字符哦!"];
        return NO;
    }
    return YES;
}

#pragma mark - verify email

- (BOOL)verifyEmail:(UITextField *)txt {
    if (! [txt.text isValidEmail]) {
        [UIAlertView showAlertMessage:@"邮箱格式不正确,请重新输入!"];
        return NO;
    }
    return YES;
}



#pragma mark - verify phoneNumber
- (BOOL)verifyPhone:(UITextField *)phone {
    if (! [phone.text isValidPhone]) {
        [UIAlertView showAlertMessage:@"手机格式不正确,请重新输入!"];
    }
    return YES;
}


@end
