//
//  MZLFilterParam.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-10.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZLSvcParamWithPaging.h"

#define MZL_FILTER_DISTANCE_REQUEST_KEY @"distance"

@class MZLModelFilterType;

@interface MZLFilterParam : MZLSvcParamWithPaging

@property (nonatomic, copy) NSString *destinationName;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, copy) NSString *crowd;
@property (nonatomic, copy) NSString *feature;

//- (void)addParamFromFilterType:(MZLModelFilterType *)filterType;
- (NSDictionary *)toDictionaryWithDistanceRequired;
+ (MZLFilterParam *)filterParamsFromFilterTypes:(NSArray *)filterTypes;
+ (MZLFilterParam *)filterParamsFromSelectedFilterOptions;

@end
