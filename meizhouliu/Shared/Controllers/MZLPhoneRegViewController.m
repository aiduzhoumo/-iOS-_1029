//
//  MZLPhoneRegViewController.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/19.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLPhoneRegViewController.h"
#import "UIViewController+MZLModelPresentation.h"
#import "UIViewController+MZLRegLoginCommon.h"
#import "MZLServices.h"
#import "MZLRegLoginResponse.h"
#import "MZLRegisterPhoneSvcParam.h"
#import "AFNetworking.h"
#import "MZLPhoneRegNameViewController.h"
#import "MZLServiceResponseObject.h"
#import "MZLRegisterPhoneSvcParam.h"
#import "RKObjectManager.h"
#import "MZLServices.h"
#import "MZLGetCodeSvcParam.h"
#import "MZLVerifyCodeSvcParam.h"
#import "CountdownButtonByTime.h"

#define SEGUE_TO_PHONEREGNAME @"toPhoneName"

@interface MZLPhoneRegViewController ()

{
 
}

@end

@implementation MZLPhoneRegViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    [self.view setBackgroundColor:colorWithHexString(@"＃D8D8D8")];

    [self initWithStatusBar:self.phoneStateBar navBar:self.phoneNavBar];
    
//    [self initInternal];
    self.isSecure = YES;
    
    [self.phoneNum setTag:TAG_TEXT_PHONENUM];
    [self.name setTag:TAG_TEXT_USER];
//    [self.secCode setTag:TAG_TEXT_]
    [self.passWord setTag:TAG_TEXT_PWD];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - validation
/**
 *  这里是验证有没有输入邮箱，昵称，密码的
 */
- (BOOL)validateInput {
    if (![self validateInputNameAndPhone]) {
        return NO;
    }
    if (! [self verifyNickName:self.name]  ||! [self verifyPhone:self.phoneNum] ) {
        return NO;
    }
   return YES;
}

/**
 *  这里是验证有没有输入邮箱，昵称，密码的
 */
- (BOOL)validateInputMore {
    if (! [super validateInput]) {
        return NO;
    }
    if (! [self verifyNickName:self.name]  ||! [self verifyPhone:self.phoneNum]  || ! [self verifyPassword:self.passWord]) {
        return NO;
    }
    return YES;
}

- (BOOL)validateInputNameAndPhone {
    if (isEmptyString(_name.text)) {
        [UIAlertView showAlertMessage:@"请填写昵称！"];
        return NO;
    }
    if (isEmptyString(_phoneNum.text)) {
        [UIAlertView showAlertMessage:@"请填写手机号！"];
        return NO;
    }
    return YES;
}


- (IBAction)canSeePassWord:(id)sender {

    self.isSecure = !self.isSecure;
    if (self.isSecure) {
        [self.canSeePassWBtn setBackgroundImage:[UIImage imageNamed:@"seePassWNot.png"] forState:UIControlStateNormal];
    }else {
        [self.canSeePassWBtn setBackgroundImage:[UIImage imageNamed:@"seePassW.png"] forState:UIControlStateNormal];
    }
    self.passWord.secureTextEntry = self.isSecure;

}


- (IBAction)getSecCode:(id)sender {
    
    [self dismissKeyboard];
    
    if ([self validateInput]) {
        
        MZLGetCodeSvcParam *param = [[MZLGetCodeSvcParam alloc] init];
        param.phone = self.phoneNum.text;
        param.type = @"register";
        [MZLServices getSecCode:param succBlock:^(NSArray *models) {

            MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
            [self hideProgressIndicator:NO];
            
            if(result.error == MZL_SVC_RESPONSE_CODE_SUCCESS) {
                NSLog(@"获取手机注册验证码成功");
                
                [CountdownButtonByTime countdownButton:_getSecCodeBtn time:59];

            }else if (result.error == MZL_RL_RCODE_GENERAL_ERROR) {
            
                [UIAlertView showAlertMessage:result.errorMessage];

            }
            
        } errorBlock:^(NSError *error) {
            
            [UIAlertView showAlertMessage:@"获取失败，请重新获取"];
            
        }];
        
    return;
        
    }
     
}

//else if (result.error == MZL_RL_RCODE_TOKEN_NOTACCQUIRED) { // server端token获取失败
////                [self onLoginErrorWithCode:ERROR_CODE_SERVER_TOKEN_ISSUE];
//                [UIAlertView showAlertMessage:@"网络繁忙"];
//            } else if (! isEmptyString(result.errorMessage)) { // 其它server返回的错误
//                [UIAlertView showAlertMessage:result.errorMessage];
//            } else { // 不明错误
////                [self onLoginErrorWithCode:ERROR_CODE_LOGIN_FAILED];
//                [UIAlertView showAlertMessage:@"网络繁忙"];
//            }
         
         
- (void)dealloc {
     
     NSLog(@"页面销毁了");
}
 
- (IBAction)nextStep:(id)sender {
    
//    这边先判断验证码，再注册
     MZLVerifyCodeSvcParam *param = [[MZLVerifyCodeSvcParam alloc] init];
     param.phone = self.phoneNum.text;
     param.type = @"register";
     param.code = self.secCode.text;
     
     [MZLServices verifyCode:param succBlock:^(NSArray *models) {
         
         MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
         [self hideProgressIndicator:NO];
         
         if(result.error == MZL_SVC_RESPONSE_CODE_SUCCESS) {
             //再进行手机号码注册
             [self dismissKeyboard];
             if (! [self validateInputMore]) {
                 return;
             }
             
             MZLRegisterPhoneSvcParam *param = [MZLRegisterPhoneSvcParam instance];
             
             param.phone = self.phoneNum.text;
             param.nickName = self.name.text;
             param.password = self.passWord.text;
             param.secCode = self.secCode.text;
             [self showRegProgressIndicator];
             
             [MZLServices registerByPhoneService:param succBlock:^(NSArray *models) {
                 
                 MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
                 [self handleRegPhoneResponse:result type:MZLLoginTypePhone];
                 
             } errorBlock:^(NSError *error) {
                 [self onRegError];
             }];

//         [self performSegueWithIdentifier:SEGUE_TO_PHONEREGNAME sender:nil];
             
         }else if (result.error == MZL_RL_RCODE_GENERAL_ERROR) {
             
             [UIAlertView showAlertMessage:result.errorMessage];
             
         }
         
     } errorBlock:^(NSError *error) {
         
         [UIAlertView showAlertMessage:@"网络开小差了~~"];
     }];
}
 
 
//#pragma mark - Navigation
// 
// // In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    [super prepareForSegue:segue sender:sender];
//    if ([SEGUE_TO_PHONEREGNAME isEqualToString:segue.identifier]) {
//        MZLPhoneRegNameViewController *name = (MZLPhoneRegNameViewController *)segue.destinationViewController;
//        name.phone = self.phoneNum.text;
//        name.passWord = self.passWord.text;
//        name.secCode = self.secCode.text;
//        name.fromController = self;
//    }
//    
//}



@end




