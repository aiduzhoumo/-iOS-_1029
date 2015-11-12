//
//  MZLSurroundingLocSvcParam.h
//  mzl_mobile_ios
//
//  Created by race on 15/1/5.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+CODictionaryParameter.h"

@class MZLLocationInfo,MZLPagingSvcParam;

@interface MZLSurroundingLocSvcParam : NSObject

@property (nonatomic, copy)NSString *latitude;
@property (nonatomic, copy)NSString *longitude;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, strong) MZLPagingSvcParam *pagingParam;

+ (instancetype)instanceWithCurLocation:(MZLLocationInfo *)locationInfo paging:(MZLPagingSvcParam *)pagingParam;

@end
