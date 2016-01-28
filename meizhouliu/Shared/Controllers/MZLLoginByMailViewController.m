//
//  MZLLoginByMailViewController.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/28.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLLoginByMailViewController.h"
#import "MZLLoginSvcParam.h"
#import "MZLServices.h"
#import "MZLRegLoginResponse.h"
#import "MZLSharedData.h"
#import "UIViewController+MZLValidation.h"
#import "UIViewController+MZLRegLoginCommon.h"
#import "TalkingDataAppCpa.h"
#import "MZLAppUser.h"

@interface MZLLoginByMailViewController ()<UINavigationBarDelegate>

@end

@implementation MZLLoginByMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self initWithStatusBar:nil navBar:self.navigationController.navigationBar];
    
    // 移除默认背景
    [self.navigationController.navigationBar setBackgroundImage:nil forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    UINavigationItem *topItem = self.navigationController.navigationBar.topItem;
    UINavigationItem *bottomItem = [[UINavigationItem alloc]init];
    bottomItem.title = @"取消";
    
    [self.navigationController.navigationBar popNavigationItemAnimated:NO];
    [self.navigationController.navigationBar pushNavigationItem:bottomItem animated:NO];
    [self.navigationController.navigationBar pushNavigationItem:topItem animated:NO];
    
    self.navigationController.navigationBar.delegate = self;
}

#pragma mark - navigation bar delegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - login

- (BOOL)validateInput {
    if (isEmptyString(self.nameTextF.text)) {
        [UIAlertView showAlertMessage:@"请填写昵称或邮箱！"];
        return NO;
    }
    if (! [super validateInput]) {
        return NO;
    }
    return YES;
}

- (IBAction)mailLoginBtn:(id)sender {
    
    [self dismissKeyboard];
    if (! [self validateInput]) {
        return;
    }
    [self showLoginProgressIndicator];
    MZLLoginSvcParam *param = [MZLLoginSvcParam loginSvcParamWithname:self.nameTextF.text password:self.passWordTextF.text];
    [MZLServices loginByNormalService:param succBlock:^(NSArray *models) {
        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
        [self handleRegLoginResponse:result type:MZLLoginTypeNormal];
    } errorBlock:^(NSError *error) {
        [self onLoginError];
    }];
    
}

- (void)handleRegLoginResponse:(MZLRegLoginResponse *)response type:(MZLLoginType)type {
    [self hideProgressIndicator:NO];
    if (response.error == MZL_SVC_RESPONSE_CODE_SUCCESS) {
        [self saveUserAndToken:response];
        [self onLogined:type];
        
        [self dismissMailCurrentViewController:self.executionBlockWhenDismissed animatedFlag:YES];
        
        [TalkingDataAppCpa onLogin:response.accessToken.token];
    } else if (response.error == MZL_RL_RCODE_GENERAL_ERROR) { // 错误码-1
        [UIAlertView showAlertMessage:response.errorMessage];
    } else if (response.error == MZL_RL_RCODE_TOKEN_NOTACCQUIRED) { // server端token获取失败
        [self onLoginErrorWithCode:ERROR_CODE_SERVER_TOKEN_ISSUE];
    } else if (! isEmptyString(response.errorMessage)) { // 其它server返回的错误
        [UIAlertView showAlertMessage:response.errorMessage];
    } else { // 不明错误
        [self onLoginErrorWithCode:ERROR_CODE_LOGIN_FAILED];
    }
}

- (void)saveUserAndToken:(MZLRegLoginResponse *)response {
    [[MZLSharedData appUser] setUser:response.user token:response.accessToken];
}

#pragma mark - tip message

- (void)showLoginProgressIndicator {
    [self showNetworkProgressIndicator:@"正在登录中..."];
}


#pragma mark - error related

- (void)onLoginError {
    [self onLoginErrorWithCode:ERROR_CODE_NETWORK];
}

- (void)onLoginErrorWithCode:(NSInteger)errorCode {
    [self hideProgressIndicator];
    NSString *message = [NSString stringWithFormat:@"登录失败，请稍后重试！(code=%@)", @(errorCode)];
    [UIAlertView showAlertMessage:message];
}

@end
