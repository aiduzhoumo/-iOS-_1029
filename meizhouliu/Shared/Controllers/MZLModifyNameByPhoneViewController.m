//
//  MZLModifyNameByPhoneViewController.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/12/3.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLModifyNameByPhoneViewController.h"
#import "UIViewController+MZLValidation.h"
#import "MZLGetCodeSvcParam.h"
#import "MZLServices.h"
#import "MZLRegLoginResponse.h"
#import "CountdownButtonByTime.h"
#import "UIViewController+MZLModelPresentation.h"
#import "UIViewController+MZLRegLoginCommon.h"
#import "MZLRegisterSinaWeiboSvcParam.h"
#import "MZLRegisterTencentQqSvcParam.h"
#import "MZLSharedData.h"
#import "MZLAppUser.h"
#import "UIImageView+MZLNetwork.h"
#import "TalkingDataAppCpa.h"
#import "IBAlertView.h"
#import "MZLBindPhoneResponse.h"

@interface MZLModifyNameByPhoneViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *statesBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction)modifyNameLogin:(id)sender;

@end

@implementation MZLModifyNameByPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithStatusBar:self.statesBar navBar:self.navBar];
    
    [self.getCodeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCode {
    
    [self dismissKeyboard];
    if (![self validateInputGetCode]) {
        return;
    }
    MZLGetCodeSvcParam *param = [[MZLGetCodeSvcParam alloc] init];
    param.phone = self.phoneTF.text;
    param.type = @"bind";
    [MZLServices getSecCode:param succBlock:^(NSArray *models) {
        
        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
        [self hideProgressIndicator:NO];
        
        if(result.error == MZL_SVC_RESPONSE_CODE_SUCCESS) {
            NSLog(@"获取三方注册验证码成功");
            
            [CountdownButtonByTime countdownButton:_getCodeBtn time:59];
            
        }else if (result.error == -1) {
            [UIAlertView showAlertMessage:result.errorMessage];
        }
    } errorBlock:^(NSError *error) {
        [UIAlertView showAlertMessage:@"获取失败，请重新获取"];
    }];
    return;

}

- (BOOL)validateInputGetCode {
    
    if (isEmptyString(_nameTF.text)) {
        return NO;
    }
    if (! [self verifyNickName:self.nameTF]) {
        return NO;
    }
    if (isEmptyString(_phoneTF.text)) {
        return NO;
    }
    if (! [self verifyPhone:self.phoneTF]) {
        return NO;
    }
    return YES;
}

- (IBAction)modifyNameLogin:(id)sender {
    
    [self modifyName];
}

- (void)modifyName {

    [self dismissKeyboard];
    if (! [self validateInputGetCode]) {
        return;
    }
    if (isEmptyString(_codeTF.text)) {
        return;
    }
    
    MZLAppUser *user = [MZLSharedData appUser];
    user.nickNameFrom3rdParty = self.nameTF.text;
    [self showRegProgressIndicator];
    //    [self reg];
    if (self.loginType == MZLLoginTypeSinaWeibo) {
        [self regWithSinaWeibo];
    } else if(self.loginType == MZLLoginTypeQQ){
        [self regWithQQ];
    } else {
        [self regWithWechat];
    }

}

//- (void)bind3rdPhone {
//   NSLog(@"[MZLSharedData appUserAccessToken] == %@",[MZLSharedData appUserAccessToken]);
//    self.token = [MZLSharedData appUserAccessToken];
//    [MZLServices bindPhoneWithToken:self.token phone:self.phoneTF.text code:self.codeTF.text succBlock:^(NSArray *models) {
//        MZLRegLoginResponse *response = (MZLRegLoginResponse *)models[0];
//        [self hideProgressIndicator:NO];
//        if (response.error == MZL_SVC_RESPONSE_CODE_SUCCESS) {
////            MZLAppUser *user = [MZLSharedData appUser];
////            user.user = response.user;
////            //user.user.phone = _phoneNumTF.text;
////            //重新保存手机号
////            [[MZLSharedData appUser] setUser:user.user token:user.token];
//            [MZLSharedData appUser].user = response.user;
//            [self onLogined:_loginType];
//        }else if (response.error == MZL_RL_RCODE_GENERAL_ERROR) {
//            [UIAlertView showAlertMessage:response.errorMessage];
//        }else {
//            [UIAlertView showAlertMessage:@"网络错误，请稍后再试"];
//        }
//    } errorBlock:^(NSError *error) {
//        [UIAlertView showAlertMessage:@"绑定失败，请稍后再试"];
//    }];
//}

#pragma mark - reg

- (void)reg {
    MZLRegisterBaseSvcParam *params = [MZLRegisterBaseSvcParam instance];
    [MZLServices registerServiceWithType:self.loginType param:params succBlock:^(NSArray *models) {
        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
        [self handleRegResponse:result type:self.loginType];
    } errorBlock:^(NSError *error) {
        [self onRegError];
    }];
}

- (void)regWithWechat{
    MZLRegister3rdPartySvcParam *params = [MZLRegister3rdPartySvcParam instance];
    [MZLServices registerByWeixinService:params succBlock:^(NSArray *models) {
        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
        [self handle3rdRegResponse:result type:MZLLoginTypeWeiXin];
    } errorBlock:^(NSError *error) {
        [self onRegError];
    }];
}

- (void)regWithSinaWeibo {
    MZLRegisterSinaWeiboSvcParam *params = [MZLRegisterSinaWeiboSvcParam instance];
    [MZLServices registerBySinaWeiboService:params succBlock:^(NSArray *models) {
        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
        [self handle3rdRegResponse:result type:MZLLoginTypeSinaWeibo];
    } errorBlock:^(NSError *error) {
        [self onRegError];
    }];
}

- (void)regWithQQ {
    MZLRegisterTencentQqSvcParam *params = [MZLRegisterTencentQqSvcParam instance];
    [MZLServices registerByTencentQqService:params succBlock:^(NSArray *models) {
        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
        [self handle3rdRegResponse:result type:MZLLoginTypeQQ];
    } errorBlock:^(NSError *error) {
        [self onRegError];
    }];
}

- (void)handle3rdRegResponse:(MZLRegLoginResponse *)response type:(MZLLoginType)type {
    [self hideProgressIndicator:NO]; // no animation, no delay
    if (response.error == MZL_SVC_RESPONSE_CODE_SUCCESS) {
        
        self.token = response.accessToken.token;
        self.accessToken = response.accessToken;
        
        if ([response.user.bind isEqualToString:@"false"]) {

            [MZLServices bindPhoneWithToken:self.token phone:self.phoneTF.text code:self.codeTF.text succBlock:^(NSArray *models) {
                MZLBindPhoneResponse *response = (MZLBindPhoneResponse *)models[0];
                [self hideProgressIndicator:NO];
                if (response.error == MZL_SVC_RESPONSE_CODE_SUCCESS) {

                    [MZLSharedData appUser].user = response.user;
                    [MZLSharedData appUser].token = self.accessToken;
//                    [[MZLSharedData appUser] setUser:[MZLSharedData appUser].user token:];
                    [self onLogined:type];
                    
                    //跳回登入界面
                    [IBAlertView showDetermineWithTitle:@"提示" message:@"注册绑定成功" dismissBlock:^{
                        __weak UIViewController *controller = [self fromController];
                        [self dismissCurrentViewController:^{
                            if (controller) {
                                [controller dismissCurrentViewController:nil animatedFlag:YES];
                            }
                        } animatedFlag:YES];
                    }];
                    
                }else if (response.error == MZL_RL_RCODE_GENERAL_ERROR) {
                    [UIAlertView showAlertMessage:response.errorMessage];
                }else {
                    [UIAlertView showAlertMessage:@"网络错误，请稍后再试"];
                }
            } errorBlock:^(NSError *error) {
                [UIAlertView showAlertMessage:@"注册绑定失败，请稍后再试"];
            }];
        }
        
        [TalkingDataAppCpa onRegister:response.accessToken.token];
    } else if (response.error == MZL_RL_RCODE_GENERAL_ERROR) { // 错误码-1
        [UIAlertView showAlertMessage:response.errorMessage];
    } else if (response.error == MZL_RL_RCODE_TOKEN_NOTACCQUIRED) { // server端token获取失败
        [IBAlertView showAlertWithTitle:nil message:@"注册成功，但自动登录失败，请稍后手动登录及绑定手机号！" dismissTitle:MZL_MSG_OK dismissBlock:^{
            [self dismissCurrentViewController];
        }];
    } else if (! isEmptyString(response.errorMessage)) { // 其它server返回的错误
        [UIAlertView showAlertMessage:response.errorMessage];
    } else { // 不明错误
        [self onRegErrorWithCode:ERROR_CODE_LOGIN_FAILED];
    }
}


@end



