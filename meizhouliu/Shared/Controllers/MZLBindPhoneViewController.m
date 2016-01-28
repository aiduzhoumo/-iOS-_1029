//
//  MZLBindPhoneViewController.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/29.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLBindPhoneViewController.h"
#import "UIViewController+MZLModelPresentation.h"
#import "MZLServices.h"
#import "MZLRegLoginResponse.h"
#import "IBAlertView.h"
#import "UIViewController+MZLRegLoginCommon.h"
#import "MZLSharedData.h"
#import "MZLGetCodeSvcParam.h"
#import "CountdownButtonByTime.h"
#import "MZLAppUser.h"
#import "MZLBindPhoneResponse.h"

@interface MZLBindPhoneViewController ()

@end

@implementation MZLBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initWithStatusBar:self.statesBar navBar:self.navBar];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getToken:) name:@"bindPhoneNum" object:nil];
    
    [self.getSecCodeBtn addTarget:self action:@selector(toGetSecCode) forControlEvents:UIControlEventTouchUpInside];
}


- (void)toGetSecCode {

    [self dismissKeyboard];
    if ( ![self validateInputToPhone]) {
        return;
    }
    
    MZLGetCodeSvcParam *param = [[MZLGetCodeSvcParam alloc] init];
    param.type = @"bind";
    param.phone = self.phoneNumTF.text;
    
    [MZLServices getSecCode:param succBlock:^(NSArray *models) {
        MZLServiceResponseObject *result = (MZLServiceResponseObject *)models[0];
        [self hideProgressIndicator:NO];
        if (result.error == MZL_SVC_RESPONSE_CODE_SUCCESS) {
            //获取成功
            [CountdownButtonByTime countdownButton:_getSecCodeBtn time:59];
            
            
        } else if (result.error == MZL_RL_RCODE_GENERAL_ERROR) { // 错误码-1
            [UIAlertView showAlertMessage:result.errorMessage];
        } else { // 不明错误
            [UIAlertView showAlertMessage:@"网络繁忙，请稍后再试"];
        }
        
    } errorBlock:^(NSError *error) {
        //        [self onRegError];
        [UIAlertView showAlertMessage:@"绑定失败，请重新绑定"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)BindPhoneNumBtn:(id)sender {
    
    [self dismissKeyboard];
    if (![self validateInputToPhone]) {
        return ; 
    }
   
    [MZLServices bindPhoneWithToken:self.token phone:self.phoneNumTF.text code:self.secCodeTF.text succBlock:^(NSArray *models) {
        MZLBindPhoneResponse *response = (MZLBindPhoneResponse *)models[0];
        [self hideProgressIndicator:NO];
        if (response.error == MZL_SVC_RESPONSE_CODE_SUCCESS) {

            MZLAppUser *user = [MZLSharedData appUser];
            user.user = response.user;

            [[MZLSharedData appUser] setUser:user.user token:user.token];
            [self onLogined:_type];
                        
            //跳回登入界面
            [IBAlertView showDetermineWithTitle:@"提示" message:@"绑定成功" dismissBlock:^{
           
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
        
        [UIAlertView showAlertMessage:@"绑定失败，请稍后再试"];
        
    }];

}

- (BOOL)validateInputToPhone {
    if (isEmptyString(self.phoneNumTF.text)) {
        [UIAlertView showAlertMessage:@"请填写手机号码！"];
        return NO;
    }
    if ( ![self verifyPhone:self.phoneNumTF] ) {
        return NO;
    }
    return YES;
}


@end
