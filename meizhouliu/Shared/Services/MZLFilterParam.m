//
//  MZLFilterParam.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-10.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFilterParam.h"
#import "MZLModelFilterType.h"

@interface MZLFilterParam() {
    NSMutableDictionary *_paramDict;
}

@end

@implementation MZLFilterParam

- (NSMutableDictionary *)_toDictionary {
    NSMutableDictionary *dict = [super _toDictionary];
    if (! isEmptyString(self.destinationName)) {
        [dict setKey:@"destination_name" strValue:self.destinationName];
    }
    if (_paramDict) {
        [dict addEntriesFromDictionary:_paramDict];
    } else {
        [dict setKey:MZL_FILTER_DISTANCE_REQUEST_KEY intValue:self.distance];
        // split by ","
        [dict setKey:@"crowd" strValue:self.crowd];
        // split by ","
        [dict setKey:@"feature" strValue:self.feature];
    }
    return dict;
}

- (NSDictionary *)toDictionaryWithDistanceRequired {
    NSMutableDictionary *dict = [self _toDictionary];
    if (! [dict hasKey:MZL_FILTER_DISTANCE_REQUEST_KEY]) {
        [dict setKey:MZL_FILTER_DISTANCE_REQUEST_KEY intValue:1];
    }
    return dict;
}

- (void)addParamFromFilterType:(MZLModelFilterType *)filterType {
    if (! _paramDict) {
        _paramDict = [NSMutableDictionary dictionary];
    }
    [_paramDict setObject:[filterType toServiceParamValue] forKey:filterType.paramName];
}

+ (MZLFilterParam *)filterParamsFromFilterTypes:(NSArray *)filterTypes {
    MZLFilterParam *param = [[MZLFilterParam alloc] init];
    for (MZLModelFilterType *filterType in filterTypes) {
        [param addParamFromFilterType:filterType];
    }
    return param;
}

+ (MZLFilterParam *)filterParamsFromSelectedFilterOptions {
    MZLFilterParam *filterParam = [MZLFilterParam filterParamsFromFilterTypes:[MZLSharedData selectedFilterOptions]];
    return filterParam;
}

@end
