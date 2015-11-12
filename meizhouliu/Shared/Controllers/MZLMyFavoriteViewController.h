//
//  MZLMyFavoriteViewController.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-17.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLTableViewController.h"

#define MZL_NOTIFICATION_MY_TO_ARTICLE @"MZL_NOTIFICATION_MY_TO_ARTICLE"

@class MZLModelUserLocationPref;
@class MZLModelUserFavoredArticle;

@interface MZLMyFavoriteViewController : MZLTableViewController<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tvMy;
@property (weak, nonatomic) IBOutlet UIView *vwTopBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnLoginSetting;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSegmentTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSegmentHeight;


//- (void)refreshMyFavoriteData;

@end
