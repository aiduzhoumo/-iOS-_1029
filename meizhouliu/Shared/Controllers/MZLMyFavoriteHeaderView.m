//
//  MZLMyFavoriteHeaderView.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/6.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import "MZLMyFavoriteHeaderView.h"

@implementation MZLMyFavoriteHeaderView

+ (id)myFavoriteHeaderViewInstance {
    
    MZLMyFavoriteHeaderView *headerView = [MZLMyFavoriteHeaderView viewFromNib:@"MZLMyFavoriteHeaderView"];
    return headerView;
}

@end
