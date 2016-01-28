//
//  UIViewController+MZLRegLoginCommon.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-7.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIViewController+MZLRegLoginCommon.h"
#import <IBMessageCenter.h>
#import "UIViewController+MZLAdditions.h"
#import "MZLRegLoginResponse.h"
#import "MZLSharedData.h"
#import "MZLAppUser.h"
#import <IBAlertView.h>
#import "MZLServices.h"
#import "TalkingDataAppCpa.h"
#import <Masonry/Masonry.h>
#import "UIImage+COAdditions.h"

#define IMAGE_EMAIL_NORMAL @"Email"
#define IMAGE_EMAIL_HIGHLIGHT @"EmailHighlight"
#define IMAGE_USER_NORMAL @"User"
#define IMAGE_USER_HIGHLIGHT @"UserHighlight"
#define IMAGE_PWD_NORMAL @"Password"
#define IMAGE_PWD_HIGHLIGHT @"PasswordHighlight"

@implementation UIViewController (MZLRegLoginCommon)

- (void)initTextFields:(NSArray *)textFields {
    for (UITextField *txt in textFields) {
        txt.backgroundColor = [UIColor whiteColor];
        txt.textColor = MZL_COLOR_BLACK_555555();
        
        txt.delegate = self;
        txt.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
}

- (void)initSeparatorView:(NSArray *)separaotors {
    for (UIView *sep in separaotors) {
        sep.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] init];
        UIImage *imageWithColor = [UIImage imageWithColor:MZL_SEPARATORS_BG_COLOR() size:CGSizeMake(CO_SCREEN_WIDTH-20, 0.5)];
        imageView.image = imageWithColor;
        imageView.contentMode = UIViewContentModeCenter;
        [sep addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(sep);
            make.left.mas_offset(sep.left).offset(10);
            make.right.mas_offset(sep.right).offset(-10);
        }];
    }
}

#pragma mark - protected

- (BOOL)validateInput {
    UITextField *txtEmail = [self textField:TAG_TEXT_EMAIL];
    if (txtEmail && isEmptyString(txtEmail.text)) {
        [UIAlertView showAlertMessage:@"请填写邮箱！"];
        return NO;
    }
    UITextField *txtUser = [self textField:TAG_TEXT_USER];
    if (txtUser && isEmptyString(txtUser.text)) {
        [UIAlertView showAlertMessage:@"请填写昵称！"];
        return NO;
    }
//    UITextField *txtUserEmail = [self textField:TAG_TEXT_USER_EMAIL];
//    if (txtUserEmail && isEmptyString(txtUserEmail.text)) {
//        return NO;
//    }
    UITextField *txtPwd = [self textField:TAG_TEXT_PWD];
    if (txtPwd && isEmptyString(txtPwd.text)) {
        [UIAlertView showAlertMessage:@"请填写密码！"];
        return NO;
    }
    return YES;
}

#pragma mark - text field delegate 

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //开始编辑时触发，文本字段将成为first responder
    NSInteger tag = textField.tag;
    UIImageView *img = [self imageView:tag + TEXT_TO_IMAGE_GAP];
    switch (tag) {
        case TAG_TEXT_USER:
            img.image = [UIImage imageNamed:IMAGE_USER_HIGHLIGHT];
            break;
        case TAG_TEXT_PWD:
            img.image = [UIImage imageNamed:IMAGE_PWD_HIGHLIGHT];
            break;
        case TAG_TEXT_EMAIL:
            img.image = [UIImage imageNamed:IMAGE_EMAIL_HIGHLIGHT];
            break;
        default:
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger tag = textField.tag;
    UIImageView *img = [self imageView:tag + TEXT_TO_IMAGE_GAP];
    switch (tag) {
        case TAG_TEXT_USER:
            img.image = [UIImage imageNamed:IMAGE_USER_NORMAL];
            break;
        case TAG_TEXT_PWD:
            img.image = [UIImage imageNamed:IMAGE_PWD_NORMAL];
            break;
        case TAG_TEXT_EMAIL:
            img.image = [UIImage imageNamed:IMAGE_EMAIL_NORMAL];
            break;
        default:
            break;
    }
}

#pragma mark - help methods

- (UITextField *)textField:(NSInteger)tag {
    return (UITextField *)[self.view viewWithTag:tag];
}

- (UIImageView *)imageView:(NSInteger)tag {
    return (UIImageView *)[self.view viewWithTag:tag];
}

#pragma mark - on logined

- (void)onLogined:(MZLLoginType)type {
//    [MZLSharedData clearLoginRemind];
    [MZLSharedData appUser].loginType = type;
    [[MZLSharedData appUser] saveInPreference];
    // 登录后，需要重新绑定deviceToken到userId上
    [MZLServices recordUserLocation:[MZLSharedData selectedCity]];
    [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_LOGINED];
}

- (void)saveUserAndToken:(MZLRegLoginResponse *)response {
    [[MZLSharedData appUser] setUser:response.user token:response.accessToken];
}

#pragma mark - error related

- (void)onRegError {
    [self onRegErrorWithCode:ERROR_CODE_NETWORK];
}

- (void)onRegErrorWithCode:(NSInteger)errorCode {
    [self hideProgressIndicator];
    NSString *message = [NSString stringWithFormat:@"注册失败，请稍后重试！(code=%@)", @(errorCode)];
    [UIAlertView showAlertMessage:message];
}

- (void)handleRegResponse:(MZLRegLoginResponse *)response type:(MZLLoginType)type {
    [self hideProgressIndicator:NO]; // no animation, no delay
    if (response.error == MZL_SVC_RESPONSE_CODE_SUCCESS) {
        [self saveUserAndToken:response];
        [self onLogined:type];
        __weak UIViewController *controller = [self fromController];
        [self dismissCurrentViewController:^{
            if (controller) {
                [controller dismissCurrentViewController:nil animatedFlag:YES];
            }
        } animatedFlag:YES];
        [TalkingDataAppCpa onRegister:response.accessToken.token];
    } else if (response.error == MZL_RL_RCODE_GENERAL_ERROR) { // 错误码-1
        [UIAlertView showAlertMessage:response.errorMessage];
    } else if (response.error == MZL_RL_RCODE_TOKEN_NOTACCQUIRED) { // server端token获取失败
        [IBAlertView showAlertWithTitle:nil message:@"注册成功，但自动登录失败，请稍后手动登录！" dismissTitle:MZL_MSG_OK dismissBlock:^{
            [self dismissCurrentViewController];
        }];
    } else if (! isEmptyString(response.errorMessage)) { // 其它server返回的错误
        [UIAlertView showAlertMessage:response.errorMessage];
    } else { // 不明错误
        [self onRegErrorWithCode:ERROR_CODE_LOGIN_FAILED];
    }
}

#pragma mark - tip message

- (void)showRegProgressIndicator {
    [self showNetworkProgressIndicator:@"注册申请中..."];
}

#pragma mark - protected

- (UIViewController *)fromController {
    return nil;
}

@end
