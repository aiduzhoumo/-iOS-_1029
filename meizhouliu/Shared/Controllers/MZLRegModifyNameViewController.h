//
//  MZLRegModifyNameViewController.h
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-6.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLBaseViewController.h"

@interface MZLRegModifyNameViewController : MZLBaseViewController

@property (weak, nonatomic) IBOutlet UIView *vwContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UIView *sepNickSep;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UITextField *txtNickName;
@property (weak, nonatomic) IBOutlet UIButton *btnChange;
@property (weak, nonatomic) IBOutlet UILabel *lblTips;
@property (weak, nonatomic) IBOutlet UIView *statusBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property (nonatomic, assign) MZLLoginType loginType;

@property (nonatomic, copy) NSString *errorMessage;

@property (nonatomic, assign) UIViewController *fromController;

@end
