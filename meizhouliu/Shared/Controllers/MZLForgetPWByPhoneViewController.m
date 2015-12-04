//
//  MZLForgetPWByPhoneViewController.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/26.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLForgetPWByPhoneViewController.h"
#import "MZLGetCodeSvcParam.h"
#import "MZLServices.h"
#import "MZLServiceResponseObject.h"
#import "UIViewController+MZLRegLoginCommon.h"
#import "MZLVerifyCodeSvcParam.h"
#import "IBAlertView.h"
#import "MZLModifyPassWordViewController.h"
#import "CountdownButtonByTime.h"

#define MZL_MODIFY_PASSWORD @"modifypassword"

@interface MZLForgetPWByPhoneViewController ()

@end

@implementation MZLForgetPWByPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}

- (IBAction)getSecCode:(id)sender {
    
    [self dismissKeyboard];
    if (! [self validateInputPhone]) {
        return;
    }
    
    MZLGetCodeSvcParam *param = [[MZLGetCodeSvcParam alloc] init];
    param.type = @"forgot";
    param.phone = self.phoneNumTF.text;
    
    [MZLServices getSecCode:param succBlock:^(NSArray *models) {
        MZLServiceResponseObject *result = (MZLServiceResponseObject *)models[0];
        [self hideProgressIndicator:NO];
        if (result.error == MZL_SVC_RESPONSE_CODE_SUCCESS) {
           //获取成功
            NSLog(@"获取短信验证码成功。。。忘记密码使用的");
            [CountdownButtonByTime countdownButton:_getSecCodeBtn time:59];
            
            
        } else if (result.error == MZL_RL_RCODE_GENERAL_ERROR) { // 错误码-1
            [UIAlertView showAlertMessage:result.errorMessage];
        } else { // 不明错误
            [UIAlertView showAlertMessage:@"网络繁忙，请稍后再试"];
        }
        
    } errorBlock:^(NSError *error) {
//        [self onRegError];
        [UIAlertView showAlertMessage:@"获取失败，请重新获取"];
    }];
    
    
}

- (BOOL)validateInputPhone {
    if (isEmptyString(self.phoneNumTF.text)) {
        [UIAlertView showAlertMessage:@"请填写手机号码！"];
        return NO;
    }
    if (! [self verifyPhone:self.phoneNumTF] ) {
        return NO;
    }
   
    return YES;
}

- (BOOL)validateInputPhoneAndCode {
    if (isEmptyString(self.phoneNumTF.text)) {
        [UIAlertView showAlertMessage:@"请填写手机号码！"];
        return NO;
    }
    if (isEmptyString(self.secCodeTF.text)) {
        [UIAlertView showAlertMessage:@"请填写验证码！"];
        return NO;
    }
    if (! [self verifyPhone:self.phoneNumTF]) {
        return NO;
    }
    
    return YES;
}

- (IBAction)nextStep:(id)sender {
    
    [self dismissKeyboard];
    if (![self validateInputPhoneAndCode]) {
        return;
    }
    
    MZLVerifyCodeSvcParam *param = [[MZLVerifyCodeSvcParam alloc] init];
    param.phone = self.phoneNumTF.text;
    param.type = @"forgot";
    param.code = self.secCodeTF.text;
    
    [MZLServices verifyCode:param succBlock:^(NSArray *models) {
        MZLServiceResponseObject *result = (MZLServiceResponseObject *)models[0];
        [self hideProgressIndicator:NO];
        if (result.error == MZL_SVC_RESPONSE_CODE_SUCCESS) {
            //校验成功，跳转下一个界面
            [self performSegueWithIdentifier:MZL_MODIFY_PASSWORD sender:nil];
            
        } else if (result.error == MZL_RL_RCODE_GENERAL_ERROR) { // 错误码-1
            [UIAlertView showAlertMessage:result.errorMessage];
        } else { // 不明错误
            [UIAlertView showAlertMessage:@"网络繁忙，请稍后再试"];
        }
        
        
    } errorBlock:^(NSError *error) {
        [UIAlertView showAlertMessage:@"验证失败，请重新验证"];
    }];
    
}



#pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([MZL_MODIFY_PASSWORD isEqualToString:segue.identifier]) {
        MZLModifyPassWordViewController *modifyPW = (MZLModifyPassWordViewController *)segue.destinationViewController;
        modifyPW.phone = self.phoneNumTF.text;
        modifyPW.code = self.secCodeTF.text;
//        modifyPW.fromController = self;z
    }

}



@end
