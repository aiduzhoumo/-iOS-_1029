//
//  MZLModityNameViewController.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/19.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import "MZLTableViewController.h"

@class MZLModelUserInfoDetail;
@interface MZLModityNameViewController : MZLTableViewController<UITextFieldDelegate>

@property (nonatomic, strong) MZLModelUserInfoDetail *userDetail;

@property (weak, nonatomic) IBOutlet UITableView *modityNameTv;
- (IBAction)save:(id)sender;
@end
