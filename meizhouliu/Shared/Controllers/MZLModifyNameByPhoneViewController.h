//
//  MZLModifyNameByPhoneViewController.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/12/3.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLBaseViewController.h"
@class MZLModelAccessToken;

@interface MZLModifyNameByPhoneViewController : MZLBaseViewController

@property (nonatomic, copy) NSString *token;

@property (nonatomic , strong) MZLModelAccessToken *accessToken;

@property (nonatomic, assign) MZLLoginType loginType;

@property (nonatomic, copy) NSString *errorMessage;

@property (nonatomic, assign) UIViewController *fromController;

@end
