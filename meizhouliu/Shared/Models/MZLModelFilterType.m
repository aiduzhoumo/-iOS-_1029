//
//  MZLModelFilterType.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-2.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelFilterType.h"
#import "MZLModelFilterItem.h"

@implementation MZLModelFilterType

+ (NSMutableDictionary *)attributeDictionary {
    NSMutableDictionary *attrDict = [super attributeDictionary];
    [attrDict fromPath:@"param_name" toProperty:@"paramName"];
    [attrDict fromPath:@"multi" toProperty:@"isMulti"];
    return attrDict;
}

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
    [mapping addRelationWithPath:@"items" andMapping:[MZLModelFilterItem rkObjectMapping]];
}

#pragma mark - coding

#define KEY_PARAM_NAME @"KEY_PARAM_NAME"
#define KEY_IS_MULTI @"KEY_IS_MULTI"
#define KEY_CODING_ITEMS @"KEY_CODING_ITEMS"

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.paramName = [aDecoder decodeObjectForKey:KEY_PARAM_NAME];
        self.isMulti = [[aDecoder decodeObjectForKey:KEY_IS_MULTI] boolValue];
        self.items = [aDecoder decodeObjectForKey:KEY_CODING_ITEMS];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.paramName forKey:KEY_PARAM_NAME];
    [aCoder encodeObject:@(self.isMulti) forKey:KEY_IS_MULTI];
    [aCoder encodeObject:self.items forKey:KEY_CODING_ITEMS];
}

#pragma mark - coping

- (id)copyWithZone:(NSZone *)zone {
    MZLModelFilterType *copied = [super copyWithZone:zone];
    copied.paramName = self.paramName;
    copied.isMulti = self.isMulti;
    return copied;
}

#pragma mark - misc

//- (NSString *)toServiceParam {
//    if (self.items.count == 0) {
//        return @"";
//    }
//    NSArray *itemIds = [self.items map:^id(MZLModelFilterItem *object) {
//        return INT_TO_STR(object.identifier);
//    }];
//    NSString *format = @"%@=%@";
//    return [NSString stringWithFormat:format, self.paramName, [itemIds componentsJoinedByString:@","]];
//}

- (BOOL)shouldIgnoreFilter {
    if (self.identifier == MZLFilterTypeDistance) {
        if (self.items.count == 1) {
            // 如果为全部
            MZLModelFilterItem *item = self.items[0];
            return item.identifier == MZL_FILTER_DISTANCE_ALL_ID;
        }
    }
    return NO;
}

- (NSString *)toServiceParamValue {
    NSArray *itemIds = [self.items map:^id(MZLModelFilterItem *object) {
        return INT_TO_STR(object.identifier);
    }];
    return [itemIds componentsJoinedByString:@","];
}

- (UIImage *)filterTypeIcon {
    switch (self.identifier) {
        case MZLFilterTypeDistance:
            return [UIImage imageNamed:@"Filter_Distance"];
            break;
        case MZLFilterTypePeople:
            return [UIImage imageNamed:@"Filter_People"];
            break;
        case MZLFilterTypeFeature:
            return [UIImage imageNamed:@"Filter_Feature"];
            break;
        default:
            break;
    }
    return nil;
}

+ (MZLModelFilterType *)distanceFilterType {
    MZLModelFilterType *typeDistance = [[MZLModelFilterType alloc] init];
    typeDistance.displayName = @"去多远";
    typeDistance.paramName = @"distance";
    typeDistance.identifier = MZLFilterTypeDistance;
    return typeDistance;
}

+ (MZLModelFilterType *)peopleFilterType {
    MZLModelFilterType *typePeople = [[MZLModelFilterType alloc] init];
    typePeople.displayName = @"和谁玩";
    typePeople.paramName = @"crowd";
    typePeople.isMulti = YES;
    typePeople.identifier = MZLFilterTypePeople;
    return typePeople;
}

+ (MZLModelFilterType *)featureFilterType {
    MZLModelFilterType *typeFeature = [[MZLModelFilterType alloc] init];
    typeFeature.displayName = @"玩什么";
    typeFeature.paramName = @"feature";
    typeFeature.isMulti = YES;
    typeFeature.identifier = MZLFilterTypeFeature;
    return typeFeature;
}

+ (NSArray *)initialFilterTypes {
    // 如果service调用失败，默认采用此filter types
    MZLModelFilterType *typeDistance = [self distanceFilterType];
    MZLModelFilterItem *item_distance_1 = [[MZLModelFilterItem alloc] init];
    item_distance_1.displayName = @"全部";
    item_distance_1.identifier = 1;
    MZLModelFilterItem *item_distance_2 = [[MZLModelFilterItem alloc] init];
    item_distance_2.displayName = @"城内";
    item_distance_2.identifier = 2;
    MZLModelFilterItem *item_distance_3 = [[MZLModelFilterItem alloc] init];
    item_distance_3.displayName = @"一小时车程";
    item_distance_3.identifier = 3;
    MZLModelFilterItem *item_distance_4 = [[MZLModelFilterItem alloc] init];
    item_distance_4.displayName = @"两小时车程";
    item_distance_4.identifier = 4;
    MZLModelFilterItem *item_distance_5 = [[MZLModelFilterItem alloc] init];
    item_distance_5.displayName = @"更远";
    item_distance_5.identifier = 5;
    typeDistance.items = @[item_distance_1, item_distance_2, item_distance_3, item_distance_4, item_distance_5];
    
    MZLModelFilterType *typePeople = [self peopleFilterType];
    MZLModelFilterItem *item_people_1 = [[MZLModelFilterItem alloc] init];
    item_people_1.displayName = @"闺蜜";
    item_people_1.identifier = 2;
    MZLModelFilterItem *item_people_2 = [[MZLModelFilterItem alloc] init];
    item_people_2.displayName = @"情侣";
    item_people_2.identifier = 3;
    MZLModelFilterItem *item_people_3 = [[MZLModelFilterItem alloc] init];
    item_people_3.displayName = @"朋友";
    item_people_3.identifier = 1;
    MZLModelFilterItem *item_people_4 = [[MZLModelFilterItem alloc] init];
    item_people_4.displayName = @"单身";
    item_people_4.identifier = 5;
    MZLModelFilterItem *item_people_5 = [[MZLModelFilterItem alloc] init];
    item_people_5.displayName = @"亲子";
    item_people_5.identifier = 4;
    MZLModelFilterItem *item_people_6 = [[MZLModelFilterItem alloc] init];
    item_people_6.displayName = @"团体";
    item_people_6.identifier = 6;
    typePeople.items = @[item_people_1, item_people_2, item_people_3, item_people_4, item_people_5, item_people_6];
    
    MZLModelFilterType *typeFeature = [MZLModelFilterType featureFilterType];
    MZLModelFilterItem *item_feature_1 = [[MZLModelFilterItem alloc] init];
    item_feature_1.displayName = @"轻奢";
    item_feature_1.identifier = 8;
    MZLModelFilterItem *item_feature_2 = [[MZLModelFilterItem alloc] init];
    item_feature_2.displayName = @"美食";
    item_feature_2.identifier = 22;
    MZLModelFilterItem *item_feature_3 = [[MZLModelFilterItem alloc] init];
    item_feature_3.displayName = @"浪漫";
    item_feature_3.identifier = 12;
    MZLModelFilterItem *item_feature_4 = [[MZLModelFilterItem alloc] init];
    item_feature_4.displayName = @"古镇";
    item_feature_4.identifier = 9;
    MZLModelFilterItem *item_feature_5 = [[MZLModelFilterItem alloc] init];
    item_feature_5.displayName = @"清净";
    item_feature_5.identifier = 10;
    MZLModelFilterItem *item_feature_6 = [[MZLModelFilterItem alloc] init];
    item_feature_6.displayName = @"摄影";
    item_feature_6.identifier = 55;
    MZLModelFilterItem *item_feature_7 = [[MZLModelFilterItem alloc] init];
    item_feature_7.displayName = @"海边";
    item_feature_7.identifier = 36;
    MZLModelFilterItem *item_feature_8 = [[MZLModelFilterItem alloc] init];
    item_feature_8.displayName = @"温泉";
    item_feature_8.identifier = 62;
    MZLModelFilterItem *item_feature_9 = [[MZLModelFilterItem alloc] init];
    item_feature_9.displayName = @"文艺";
    item_feature_9.identifier = 7;
    MZLModelFilterItem *item_feature_10 = [[MZLModelFilterItem alloc] init];
    item_feature_10.displayName = @"户外";
    item_feature_10.identifier = 98;
    MZLModelFilterItem *item_feature_11 = [[MZLModelFilterItem alloc] init];
    item_feature_11.displayName = @"露营";
    item_feature_11.identifier = 101;
    MZLModelFilterItem *item_feature_12 = [[MZLModelFilterItem alloc] init];
    item_feature_12.displayName = @"游山";
    item_feature_12.identifier = 99;
    MZLModelFilterItem *item_feature_13 = [[MZLModelFilterItem alloc] init];
    item_feature_13.displayName = @"热闹";
    item_feature_13.identifier = 11;
    MZLModelFilterItem *item_feature_14 = [[MZLModelFilterItem alloc] init];
    item_feature_14.displayName = @"玩水";
    item_feature_14.identifier = 100;
    MZLModelFilterItem *item_feature_15 = [[MZLModelFilterItem alloc] init];
    item_feature_15.displayName = @"复古";
    item_feature_15.identifier = 80;
    MZLModelFilterItem *item_feature_16 = [[MZLModelFilterItem alloc] init];
    item_feature_16.displayName = @"夜生活";
    item_feature_16.identifier = 23;
    MZLModelFilterItem *item_feature_17 = [[MZLModelFilterItem alloc] init];
    item_feature_17.displayName = @"特色街";
    item_feature_17.identifier = 102;
    MZLModelFilterItem *item_feature_18 = [[MZLModelFilterItem alloc] init];
    item_feature_18.displayName = @"古迹";
    item_feature_18.identifier = 43;
    typeFeature.items = @[item_feature_1, item_feature_2, item_feature_3, item_feature_4, item_feature_5, item_feature_6, item_feature_7,item_feature_8, item_feature_9, item_feature_10, item_feature_11, item_feature_12, item_feature_13, item_feature_14,item_feature_15,item_feature_16,item_feature_17,item_feature_18];
    
    return @[typeDistance, typePeople, typeFeature];
}

+ (void)bindFilterItemTypeAndImage:(NSArray *)filterOptions {
    for (MZLModelFilterType *filterType in filterOptions) {
        if (filterType.identifier == MZLFilterTypePeople) {
            for ( int i = 0 ; i < filterType.items.count; i++) {
                ((MZLModelFilterItem *)filterType.items[i]).itemType = MZLFilterItemTypeImage;
                ((MZLModelFilterItem *)filterType.items[i]).imageName = imagesOfCrowd()[i];
            }
        } else if (filterType.identifier == MZLFilterTypeFeature) {
            NSInteger maxImageFeatureCount = 12;
            NSInteger upperBound = MIN(maxImageFeatureCount, filterType.items.count);
            for (int i = 0 ; i < upperBound; i++ ) {
                ((MZLModelFilterItem *)filterType.items[i]).itemType = MZLFilterItemTypeImage;
                ((MZLModelFilterItem *)filterType.items[i]).imageName = imagesOfFeature()[i];
            }
            // 其余为文字标签
            for (NSUInteger i = upperBound; i < filterType.items.count; i ++) {
                ((MZLModelFilterItem *)filterType.items[i]).itemType = MZLFilterItemTypeLabel;
            }
        } else {
            // 默认为文字标签
            for (MZLModelFilterItem *item in filterType.items) {
                item.itemType = MZLFilterItemTypeLabel;
            }
        }
    }
}

+ (BOOL)isFilterTypesTheSame:(NSArray *)aFilterTypeArray anotherFilterTypeArray:(NSArray *)anotherFilterTypeArray {
    if (aFilterTypeArray.count != anotherFilterTypeArray.count) {
        return NO;
    }
    for (int i = 0; i < aFilterTypeArray.count; i ++) {
        MZLModelFilterType *typeA = aFilterTypeArray[i];
        MZLModelFilterType *typeB = anotherFilterTypeArray[i];
        if (typeA.identifier != typeB.identifier || typeA.items.count != typeB.items.count) {
            return NO;
        }
    }
    return YES;
}

+ (NSArray *)mergeFilterTypes:(NSArray *)oldTypes new:(NSArray *)newTypes {
    if (! oldTypes || oldTypes.count == 0) {
        return newTypes;
    }
    NSMutableArray *temp = [NSMutableArray arrayWithArray:newTypes];
    for (MZLModelFilterType *typeOld in oldTypes) {
        BOOL findFlag = NO;
        for (MZLModelFilterType *typeNew in newTypes) {
            if (typeNew.identifier == typeOld.identifier) {
                findFlag = YES;
                break;
            }
        }
        if (! findFlag && typeOld.identifier == MZLFilterTypeDistance) {
            [temp addObject:typeOld];
        }
    }
    return temp;
}

+ (NSArray *)excludeDistanceTypeFromFilters:(NSArray *)filterTypes {
    return [filterTypes select:^BOOL(MZLModelFilterType *filterType) {
        return filterType.identifier != MZLFilterTypeDistance;
    }];
}

+ (NSArray *)intersectFilterTypesFromA:(NSArray *)a withB:(NSArray *)b {
    NSMutableArray *result = [NSMutableArray array];
    for (MZLModelFilterType *ft1 in a) {
        for (MZLModelFilterType *ft2 in b) {
            if (ft2.identifier == ft1.identifier) {
                [result addObject:ft1];
                break;
            }
        }
    }
    return result;
}

@end
