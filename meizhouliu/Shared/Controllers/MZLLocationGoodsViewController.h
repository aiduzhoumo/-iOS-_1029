//
//  MZLLocationGoodsViewController.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-19.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLTableViewController.h"

@class MZLModelLocationBase;

@interface MZLLocationGoodsViewController : MZLTableViewController

@property (nonatomic, strong) MZLModelLocationBase *locationParam;

@end
