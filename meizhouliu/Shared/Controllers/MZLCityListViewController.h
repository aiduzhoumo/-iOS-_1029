//
//  MZLCityListViewController.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-8.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLBaseViewController.h"

@class MZLArticleListViewController;
@interface MZLCityListViewController : MZLBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITableView *tvCityList;
@property (weak, nonatomic) IBOutlet UIView *bgStatusBar;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@end
