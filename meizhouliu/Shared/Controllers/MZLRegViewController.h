//
//  MZLRegViewController.h
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-6.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLBaseViewController.h"

@interface MZLRegViewController : MZLBaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *vwContent;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIView *statusBar;
@property (weak, nonatomic) IBOutlet UIImageView *imgEmail;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UIImageView *imgPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtUser;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd;
@property (weak, nonatomic) IBOutlet UIView *sepEmail;
@property (weak, nonatomic) IBOutlet UIView *sepUser;
@property (weak, nonatomic) IBOutlet UIView *sepPwd;

@property (weak, nonatomic) IBOutlet UIButton *btnReg;

@property (nonatomic, weak) UIViewController *fromController;

@end
