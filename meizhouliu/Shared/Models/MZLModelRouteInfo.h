//
//  MZLModelRouteInfo.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-26.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"

@interface MZLModelRouteInfo : MZLModelObject

/* 标识是第几天的路程信息 */
@property (nonatomic, assign) NSInteger dayInfo;
/* map的是MZLModelLocation */
@property (nonatomic, strong) NSArray *destinations;

@end
