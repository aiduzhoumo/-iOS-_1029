//
//  MZLForgetPWByPhoneViewController.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/26.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLBaseViewController.h"

@interface MZLForgetPWByPhoneViewController : MZLBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;

@property (weak, nonatomic) IBOutlet UITextField *secCodeTF;

@property (weak, nonatomic) IBOutlet UIButton *getSecCodeBtn;

- (IBAction)nextStep:(id)sender;
- (IBAction)getSecCode:(id)sender;

@end
