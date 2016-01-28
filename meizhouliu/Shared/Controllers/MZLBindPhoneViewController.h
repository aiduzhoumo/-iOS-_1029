//
//  MZLBindPhoneViewController.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/29.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLBaseViewController.h"

@interface MZLBindPhoneViewController : MZLBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *secCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *getSecCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *statesBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (copy, nonatomic) NSString *token;

@property (nonatomic, weak) UIViewController *fromController;
@property (nonatomic, assign) MZLLoginType type;

- (IBAction)BindPhoneNumBtn:(id)sender;


@end
