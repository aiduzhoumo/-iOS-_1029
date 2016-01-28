//
//  MZLMyNormalFavoriteHeaderView.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/18.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import "MZLMyAuthorFavoriteHeaderView.h"

@implementation MZLMyAuthorFavoriteHeaderView

+ (id)authorFavoriteHeaderViewWithSize:(CGSize)parentViewSize {
    MZLMyAuthorFavoriteHeaderView *headerView = [UIView viewFromNib:@"MZLMyAuthorFavoriteHeaderView"];
    headerView.frame = CGRectMake(0, 0, parentViewSize.width, MZLMyFavoriteHeaderViewHeight);
    [headerView initWithMyFavoriteHeaderView];
    return headerView;
}

#pragma mark - override

- (NSArray *)array:(NSArray *)array addFirstObject:(id)object {
    NSMutableArray *result = [NSMutableArray arrayWithObject:object];
    [result addObjectsFromArray:array];
    return result;
}

- (NSArray *)tabNames {
    return [self array:[super tabNames] addFirstObject:@"去过"];
}

- (NSArray *)tabIcons {
    return [self array:[super tabIcons] addFirstObject:@"tab_my_article"];
}

- (NSArray *)tabSelectedIcons {
    return [self array:[super tabSelectedIcons] addFirstObject:@"tab_my_article_sel"];
}

- (NSArray *)tabIndexes {
    return [self array:[super tabIndexes] addFirstObject:@(MZL_MY_ARTICLE_INDEX)];
}


@end
