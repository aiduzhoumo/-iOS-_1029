//
//  MZLForgetPWByMailViewController.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/27.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLForgetPWByMailViewController.h"
#import "IBAlertView.h"
#import "UIViewController+MZLValidation.h"
#import "MZLServices.h"
#import "MZLServiceResponseObject.h"

#define GEGUE_TOFORGETPW_BYEMAIL @"toforgetpwbyemail"
@interface MZLForgetPWByMailViewController ()

@end

@implementation MZLForgetPWByMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



- (IBAction)nextStep:(id)sender {
    
    [self dismissKeyboard];
    if (![self validateInforMail]) {
        return ;
    }
    
    [self showNetworkProgressIndicator];
    [MZLServices forgetPassWordByEmail:self.mailTF.text succBlock:^(NSArray *models) {
        MZLServiceResponseObject *object = (MZLServiceResponseObject *)models[0];
        if (object.error == MZL_SVC_RESPONSE_CODE_SUCCESS) {
            
            [self hideProgressIndicator];
            [self performSegueWithIdentifier:GEGUE_TOFORGETPW_BYEMAIL sender:nil];
        }
    } errorBlock:^(NSError *error) {
        [self hideProgressIndicator];
        [UIAlertView showAlertMessage:@"该用户未绑定"];
    }];
    
}

- (BOOL)validateInforMail {
    
    if (isEmptyString(_mailTF.text)) {
        [UIAlertView showAlertMessage:@"请填写邮箱！"];
        return NO;
    }
    if (![self verifyEmail:_mailTF]) {
        return NO;
    }
    return YES;
    
}

@end


