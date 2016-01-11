//
//  MZLFeriendListViewController.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/6.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLBaseViewController.h"

@class MZLModelUser;

@interface MZLFeriendListViewController : MZLBaseViewController

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong) MZLModelUser *user;

@end
