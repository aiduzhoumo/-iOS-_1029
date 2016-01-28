//
//  MZLModifyPassWordViewController.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/27.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLModifyPassWordViewController.h"
#import "MZLServices.h"
#import "MZLServiceResponseObject.h"
#import "MZLRegLoginResponse.h"
#import "UIViewController+MZLRegLoginCommon.h"
#import "MZLLoginViewController.h"
#import "MZLSharedData.h"
#import "MZLChooseModeViewController.h"
#import "IBAlertView.h"

@interface MZLModifyPassWordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passWordNew;

@property (weak, nonatomic) IBOutlet UITextField *confrimNewPassWord;

- (IBAction)confrimModify:(id)sender;

@end

@implementation MZLModifyPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)confrimModify:(id)sender {
    
    //1.先判断两次密码是否一样
    //2.一样再发送put请求，不一样弹框提示
    //3.跳回登入界面
    
    if ([self.passWordNew.text isEqualToString:self.confrimNewPassWord.text]) {
        
        [MZLServices modifyPasswordWithNewPassword:self.passWordNew.text phone:self.phone code:self.code succBlock:^(NSArray *models) {
            
            MZLRegLoginResponse *response = (MZLRegLoginResponse *)models[0];
            [self hideProgressIndicator:NO];
            if (response.error == MZL_SVC_RESPONSE_CODE_SUCCESS) {
//                [self saveUserAndToken:response];
//                [MZLSharedData setAppUser:response.user];
                
                //跳回登入界面
                [IBAlertView showDetermineWithTitle:@"提示" message:@"修改成功" dismissBlock:^{
                    NSArray *controllers = self.navigationController.viewControllers;
                    for (int i = 0; i< controllers.count ; i++) {
//                        NSLog(@"controllers[%d] == %@",i,controllers[i]);
                    }
                    
                     [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                }];
                
            }else if (response.error == MZL_RL_RCODE_GENERAL_ERROR) {
                [UIAlertView showAlertMessage:response.errorMessage];
            }else {
                [UIAlertView showAlertMessage:@"网络错误，请稍后再试"];
            }
            
        } errorBlock:^(NSError *error) {
            [UIAlertView showAlertMessage:@"网络错误,请稍后再试"];
        }];
    
    }else {
    
        [UIAlertView showAlertMessage:@"密码不一致，请正确填写" title:@"提示"];
    }
    
}

@end
