//
//  MZLLocationHeaderView.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-16.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeView.h"

#define HEIGHT_LOCATION_HEADER 45.0
#define HEIGHT_LOCATION_HEADER_VISIBLE 27.0
#define VERTICAL_INSET_LOCATION_HEADER 9.0

@class MZLLocationHeaderInfo, MZLLocationHeaderContainer;

@interface MZLLocationHeaderView : WeView

+ (MZLLocationHeaderView *)headerView:(MZLLocationHeaderInfo *)headerInfo container:(MZLLocationHeaderContainer *)container y:(CGFloat)y;
//+ (MZLLocationHeaderView *)headerView:(MZLLocationHeaderInfo *)headerInfo;

@property (nonatomic, weak) MZLLocationHeaderInfo *headerInfo;
@property (nonatomic, weak) MZLLocationHeaderContainer *container;

@end
