//
//  MZLPasswordViewController.h
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLTableViewController.h"

@interface MZLPasswordViewController : MZLTableViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tvPassword;

- (IBAction)save:(id)sender;

@end
