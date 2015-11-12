//
//  MZLIntroductionViewController.h
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLTableViewController.h"
#import "SBPickerSelector.h"

@class MZLModelUserInfoDetail;

@interface MZLIntroductionViewController : MZLTableViewController <UITextViewDelegate, SBPickerSelectorDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tvIntro;
@property (nonatomic, weak) IBOutlet UILabel *lblIntro;

@property (nonatomic, strong) MZLModelUserInfoDetail *userDetail;

- (IBAction)save:(id)sender;

@end
