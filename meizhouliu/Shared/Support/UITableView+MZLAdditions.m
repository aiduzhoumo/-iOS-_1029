//
//  UITableView+MZLAdditions.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-10.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UITableView+MZLAdditions.h"

@implementation UITableView (MZLAdditions)

#pragma mark - reusable cells

- (void)registerLocationItemCell {
    [self registerNib:[UINib nibWithNibName:@"MZLLocationItemCell" bundle:nil] forCellReuseIdentifier:MZL_REUSEID_LOCATIONCELL];
}

- (void)registerArticleItemCell {
    [self registerNib:[UINib nibWithNibName:@"MZLArticleItemTableViewCell" bundle:nil] forCellReuseIdentifier:MZL_REUSEID_ARTICLECELL];
}

- (MZLLocationItemCell *)dequeueReusableLocationItemCell {
    return [self dequeueReusableTableViewCell:MZL_REUSEID_LOCATIONCELL];
}

- (MZLArticleItemTableViewCell *)dequeueReusableArticleItemCell {
    return [self dequeueReusableTableViewCell:MZL_REUSEID_ARTICLECELL];
}

- (MZLNotificationItemTableViewCell *) dequeueReusableNotificationItemCell {
    return [self dequeueReusableTableViewCell:MZL_REUSEID_NOTIFICATIONCELL];
}

- (MZLCommentItemCell *)dequeueReusableCommentItemCell {
    return [self dequeueReusableTableViewCell:MZL_REUSEID_COMMENTCELL];
}

- (MZLGoodsItemCell *)dequeueReusableGoodsItemCell {
    return [self dequeueReusableTableViewCell:MZL_REUSEID_GOODSCELL];
}

- (MZLShortArticleChooseLocItemCell *)dequeueReusableChooseLocItemCell {
    return [self dequeueReusableTableViewCell:MZL_REUSEID_CHOOSELOCCELL];
}

- (void)registerCellForNoResult {
    [self registerNib:[UINib nibWithNibName:@"MZLTableViewCellForNoResult" bundle:nil] forCellReuseIdentifier:MZL_REUSEID_NORESULTCELL];
}

- (id)dequeueReusableTableViewCell:(NSString *)reuseIdentifier {
    id result = [self dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (! result) {
        [self registerTableViewCell:reuseIdentifier];
        result = [self dequeueReusableCellWithIdentifier:reuseIdentifier];
    }
    return result;
}

- (void)registerTableViewCell:(NSString *)identifier {
    [self registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
}

#pragma mark - misc

- (void)removeUnnecessarySeparators {
    self.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

@end
