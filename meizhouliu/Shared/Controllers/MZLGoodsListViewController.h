//
//  MZLGoodsListViewController.h
//  mzl_mobile_ios
//
//  Created by race on 14/12/5.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLTableViewController.h"

@class MZLModelArticle;

@interface MZLGoodsListViewController : MZLTableViewController
@property (weak, nonatomic) IBOutlet UITableView *tvGoods;
@property (strong, nonatomic) MZLModelArticle *article;

@end
