//
//  MZLMyFavoriteHeaderView.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/6.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import "MZLMyNormalFavoriteHeaderView.h"
#import "UIView+COAdditions.h"

@implementation MZLMyNormalFavoriteHeaderView

+ (id)normalFavoriteHeaderViewWithSize:(CGSize)parentViewSize {
    MZLMyNormalFavoriteHeaderView *headerView = [UIView viewFromNib:@"MZLMyNormalFavoriteHeaderView"];
    headerView.frame = CGRectMake(0, 0, parentViewSize.width, MZLMyFavoriteHeaderViewHeight);
    [headerView initWithMyFavoriteHeaderView];
    return headerView;
}

@end





