//
//  UIViewController+MZLRegLoginCommon.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-7.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+COTextFieldDelegate.h"
#import "UIViewController+MZLValidation.h"

#define MZL_RL_RCODE_GENERAL_ERROR -1
// 三方登录
#define MZL_RL_RCODE_USER_NOTEXIST -1
// 三方注册
#define MZL_RL_RCODE_USER_ALREADY_EXIST -1
// server端token未获取
#define MZL_RL_RCODE_TOKEN_NOTACCQUIRED -2

#define ERROR_CODE_REGISTER_FAILED -100
#define ERROR_CODE_LOGIN_FAILED -101
#define ERROR_CODE_GET_TOKEN_FAILED -102
#define ERROR_CODE_API_INVOKATION_FAILED -103
#define ERROR_CODE_USER_INFO_NOT_ACCQUIRED -104
#define ERROR_CODE_SERVER_TOKEN_ISSUE -105
#define ERROR_CODE_OAUTH_FAILED -106
#define ERROR_CODE_NETWORK -199

#define TAG_TEXT_EMAIL 100
#define TAG_TEXT_USER 101
#define TAG_TEXT_PWD 102
#define TAG_TEXT_PHONENUM 103
//#define TAG_TEXT_USER_EMAIL 104

#define TEXT_TO_IMAGE_GAP 100

#define TAG_IMAGE_EMAIL (TAG_TEXT_EMAIL + TEXT_TO_IMAGE_GAP)
#define TAG_IMAGE_USER (TAG_TEXT_USER + TEXT_TO_IMAGE_GAP)
#define TAG_IMAGE_PWD (TAG_TEXT_PWD + TEXT_TO_IMAGE_GAP)
//#define TAG_IMAGE_USER_EMAIL (TAG_TEXT_USER_EMAIL + TEXT_TO_IMAGE_GAP)

@class MZLRegLoginResponse;

@interface UIViewController (MZLRegLoginCommon)

@property (nonatomic, copy) NSString *token;

- (BOOL)validateInput;

- (void)initTextFields:(NSArray *)textFields;
- (void)initSeparatorView:(NSArray *)separaotors;

- (void)onLogined:(MZLLoginType)type;
- (void)saveUserAndToken:(MZLRegLoginResponse *)response;

- (void)onRegError;
- (void)onRegErrorWithCode:(NSInteger)errorCode;
- (void)handleRegResponse:(MZLRegLoginResponse *)response type:(MZLLoginType)type;
- (void)handleRegPhoneResponse:(MZLRegLoginResponse *)response type:(MZLLoginType)type;

- (void)showRegProgressIndicator;

- (UIViewController *)fromController;

@end
