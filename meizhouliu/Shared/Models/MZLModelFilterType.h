//
//  MZLModelFilterType.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-2.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelFilterObject.h"

typedef NS_ENUM(NSInteger, MZLFilterType) {
    MZLFilterTypeDistance = 1,
    MZLFilterTypePeople  = 2,
    MZLFilterTypeFeature  = 3
};

@interface MZLModelFilterType : MZLModelFilterObject

/** service url 中的参数名字 */
@property (nonatomic, copy) NSString *paramName;
/** 是否支持多选 */
@property (nonatomic, assign) BOOL isMulti;
@property (nonatomic, strong) NSArray *items;

- (UIImage *)filterTypeIcon;
- (NSString *)toServiceParamValue;
- (BOOL)shouldIgnoreFilter;

+ (MZLModelFilterType *)distanceFilterType;
+ (MZLModelFilterType *)peopleFilterType;
+ (MZLModelFilterType *)featureFilterType;
+ (NSArray *)initialFilterTypes;
+ (void)bindFilterItemTypeAndImage:(NSArray *)filterOptions;

+ (BOOL)isFilterTypesTheSame:(NSArray *)aFilterTypeArray anotherFilterTypeArray:(NSArray *)anotherFilterTypeArray;
+ (NSArray *)mergeFilterTypes:(NSArray *)oldTypes new:(NSArray *)newTypes;
+ (NSArray *)excludeDistanceTypeFromFilters:(NSArray *)filterTypes;
+ (NSArray *)intersectFilterTypesFromA:(NSArray *)a withB:(NSArray *)b;

@end
