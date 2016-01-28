//
//  MZLChooseModeViewController.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/27.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLBaseViewController.h"

@interface MZLChooseModeViewController : MZLBaseViewController


@property (weak, nonatomic) IBOutlet UIButton *chooseModeByPhoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseModeByMailBtn;

//@property (assign, nonatomic) BOOL isChoosePhoneBtn;

- (IBAction)chooseModeByPhone:(id)sender;
- (IBAction)chooseModeBymail:(id)sender;



@end
