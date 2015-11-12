//
//  UITableView+MZLAdditions.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-10.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLArticleItemTableViewCell.h"
#import "MZLLocationItemCell.h"
#import "MZLCommentItemCell.h"
#import "MZLGoodsItemCell.h"
#import "MZLNotificationItemTableViewCell.h"
#import "MZLShortArticleChooseLocItemCell.h"
@interface UITableView (MZLAdditions)

//- (void)registerArticleItemCell;
- (MZLArticleItemTableViewCell *)dequeueReusableArticleItemCell;

//- (void)registerLocationItemCell;
- (MZLLocationItemCell *)dequeueReusableLocationItemCell;

- (MZLCommentItemCell *)dequeueReusableCommentItemCell;

- (MZLGoodsItemCell *)dequeueReusableGoodsItemCell;

- (MZLNotificationItemTableViewCell *)dequeueReusableNotificationItemCell;

- (MZLShortArticleChooseLocItemCell *)dequeueReusableChooseLocItemCell;

- (id)dequeueReusableTableViewCell:(NSString *)reuseIdentifier;
- (void)registerCellForNoResult;

/** remove separators by setting table footer view with size zero */
- (void)removeUnnecessarySeparators;

@end
