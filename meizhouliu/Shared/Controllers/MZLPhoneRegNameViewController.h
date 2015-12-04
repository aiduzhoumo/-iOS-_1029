//
//  MZLPhoneRegNameViewController.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/24.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLBaseViewController.h"

@interface MZLPhoneRegNameViewController : MZLBaseViewController

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *passWord;
@property (copy, nonatomic) NSString *secCode;
@property (copy, nonatomic) NSString *phone;

@property (weak, nonatomic) IBOutlet UIView *nameStateBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *nameNavBar;
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
- (IBAction)completRegister:(id)sender;


@property (weak, nonatomic) UIViewController *fromController;

@end
