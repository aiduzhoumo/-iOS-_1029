//
//  MZLLocationListViewController.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-15.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLTableViewControllerWithFilter.h"

@interface MZLLocationListViewController : MZLTableViewControllerWithFilter

@property (weak, nonatomic) IBOutlet UITableView *tvLocationList;

@end
