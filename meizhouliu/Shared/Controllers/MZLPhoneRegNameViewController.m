//
//  MZLPhoneRegNameViewController.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/24.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLPhoneRegNameViewController.h"
#import "MZLRegisterPhoneSvcParam.h"
#import "UIViewController+MZLRegLoginCommon.h"
#import "MZLServices.h"
#import "UIViewController+MZLModelPresentation.h"


@interface MZLPhoneRegNameViewController ()

@end

@implementation MZLPhoneRegNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initWithStatusBar:self.nameStateBar navBar:self.nameNavBar];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - validation

- (BOOL)validateInput {
    if (! [super validateInput]) {
        return NO;
    }
    if (! [self verifyNickName:self.nameTextfield] ) {
        return NO;
    }
    return YES;
}


    


- (IBAction)completRegister:(id)sender {
    
    [self dismissKeyboard];
    if (! [self validateInput]) {
        return;
    }
    
    MZLRegisterPhoneSvcParam *param = [MZLRegisterPhoneSvcParam instance];
    
    param.phone = self.phone;
    param.nickName = self.nameTextfield.text;
    param.password = self.passWord;
    param.secCode = self.secCode;
    [self showRegProgressIndicator];
    
    [MZLServices registerByPhoneService:param succBlock:^(NSArray *models) {
        
        MZLRegLoginResponse *result = ((MZLRegLoginResponse *)models[0]);
//      [self handleRegResponse:result type:MZLLoginTypePhone];
       [self handleRegPhoneResponse:result type:MZLLoginTypePhone];
        
        NSLog(@"result = %@",result);
        
        NSLog(@"self.fromController = %@",self.fromController);
        
//       [self.fromController dismissViewControllerAnimated:YES completion:^{
//           NSLog(@"页面消失了");
//       }];
        
        
    } errorBlock:^(NSError *error) {
        [self onRegError];
    }];
}
@end
