//
//  MZLPhoneRegViewController.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/19.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLBaseViewController.h"

@interface MZLPhoneRegViewController : MZLBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *getSecCodeBtn;
@property (weak, nonatomic) IBOutlet UINavigationBar *phoneNavBar;
@property (weak, nonatomic) IBOutlet UIView *phoneStateBar;
@property (weak, nonatomic) IBOutlet UITextField *secCode;
@property (weak, nonatomic) IBOutlet UIButton *canSeePassWBtn;
@property (weak, nonatomic) IBOutlet UITextField *name;


@property (assign, nonatomic) BOOL isSecure;

- (IBAction)canSeePassWord:(id)sender;
- (IBAction)getSecCode:(id)sender;
- (IBAction)nextStep:(id)sender;

@property (nonatomic, weak) UIViewController *fromController;
@end
