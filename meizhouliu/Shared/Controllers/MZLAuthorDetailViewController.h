//
//  MZLAuthorDetailViewController.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-22.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLTableViewController.h"

@class MZLModelAuthor;

@interface MZLAuthorDetailViewController : MZLTableViewController

@property (nonatomic, strong) MZLModelAuthor *authorParam;
@property (weak, nonatomic) IBOutlet UITableView *tvAuthor;

@end
