//
//  MZLMailLoginView.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/29.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZLMailLoginView : UIView

@property (weak, nonatomic) IBOutlet UITextField *mailOrNameTF;

@property (weak, nonatomic) IBOutlet UITextField *passWordTF;

@property (weak, nonatomic) IBOutlet UIButton *mailLoginBtn;

@property (weak, nonatomic) IBOutlet UIButton *mailForgetPassWord;

@property (weak, nonatomic) IBOutlet UIButton *phoneLoginInMailView;


+ (id)mailLoginViewInstance;

+ (void)removeFromCurrentView;

@end
