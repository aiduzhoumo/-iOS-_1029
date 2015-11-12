//
//  MZLShortArticleContentVC.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-12-29.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLBaseViewController.h"
#import "COAssets.h"

#define MZL_NOTIFICATION_SA_TAKE_PHOTO @"MZL_NOTIFICATION_SA_TAKE_PHOTO"
#define MZL_NOTIFICATION_SA_PHOTO_STATUS_MODIFIED @"MZL_NOTIFICATION_SA_PHOTO_STATUS_MODIFIED"
#define MZL_NOTIFICATION_SA_PHOTO_REMOVED @"MZL_NOTIFICATION_SA_PHOTO_REMOVED"
#define MZL_NOTIFICATION_SA_TUSDK_EDIT_PHOTO @"MZL_NOTIFICATION_SA_TUSDK_EDIT_PHOTO"
#define MZL_SA_KEY_PHOTO_ITEM_VIEW @"MZL_SA_KEY_PHOTO_ITEM_VIEW"
#define MZL_SA_KEY_PHOTO_ITEM @"MZL_SA_KEY_PHOTO_ITEM"
#define MZL_SA_PHOTO_CELL_H_MARGIN 11.0
#define MZL_SA_PHOTO_CELL_V_MARGIN MZL_SA_PHOTO_CELL_H_MARGIN

@class MZLModelShortArticle;

@interface MZLShortArticleContentVC : MZLBaseViewController <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, COAssetsProtocol>

@property (nonatomic, strong) MZLModelShortArticle *model;

@end
