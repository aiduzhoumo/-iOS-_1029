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
//@property (weak, nonatomic) IBOutlet UIView *vwTopBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnLoginSetting;

<<<<<<< HEAD
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSegmentTop;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSegmentHeight;
//
//@property (weak, nonatomic) IBOutlet UIView *textVIew;
//
//@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
//@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
//@property (weak, nonatomic) IBOutlet UILabel *attentionLbl;
//@property (weak, nonatomic) IBOutlet UILabel *attentionCountLbl;
//@property (weak, nonatomic) IBOutlet UILabel *fensiLbl;
//@property (weak, nonatomic) IBOutlet UILabel *fensiCountLbl;
//@property (weak, nonatomic) IBOutlet UILabel *introdutionLbl;

=======
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSegmentTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consSegmentHeight;
>>>>>>> parent of d1afe84... Merge branch 'mzl_FJbranch'


//- (void)refreshMyFavoriteData;

@end
