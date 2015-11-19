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
#import "MZLRegisterNormalSvcParam.h"
#import "MZLRegLoginResponse.h"

@interface MZLPhoneRegViewController ()

@end

@implementation MZLPhoneRegViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initWithStatusBar:self.phoneStateBar navBar:self.phoneNavBar];
//    [self initInternal];


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

- (IBAction)canSeePassWord:(id)sender {

    NSLog(@"能看见密码");
}

- (IBAction)getSecCode:(id)sender {
    
    NSLog(@"获取验证码");
}

- (IBAction)nextStep:(id)sender {

    NSLog(@"下一步");
}
@end
