//
//  MZLLoginByMailViewController.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/28.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLBaseViewController.h"
#import "MZLLoginViewController.h"

@interface MZLLoginByMailViewController : MZLBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextF;

@property (weak, nonatomic) IBOutlet UITextField *passWordTextF;

- (IBAction)mailLoginBtn:(id)sender;

@property (nonatomic, copy) CO_BLOCK_VOID executionBlockWhenDismissed;
@property (nonatomic, assign) MZLLoginPopupFrom popupFrom;


@end
