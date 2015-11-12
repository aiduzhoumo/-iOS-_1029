//
//  MZLPersonalizeSvcParam.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-12-16.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLPersonalizeSvcParam.h"

@implementation MZLPersonalizeSvcParam

- (NSMutableDictionary *)_toDictionary {
    NSMutableDictionary *dict = [super _toDictionary];
    if (! isEmptyString(self.currentLocationName)) {
        [dict setKey:@"destination_name" strValue:self.currentLocationName];
    }
    if (self.categoryId > 0) {
        [dict setKey:@"category_id" intValue:self.categoryId];
    }
    if (self.topLocationId > 0) {
        [dict setKey:@"top_id" intValue:self.topLocationId];
    }
    return dict;
}

+ (instancetype)instanceWithCurLocation:(NSString *)curLocation topLocationId:(NSInteger)topLocationId categoryId:(NSInteger)categoryId {
    MZLPersonalizeSvcParam *param = [[MZLPersonalizeSvcParam alloc] init];
    param.currentLocationName = curLocation;
    param.topLocationId = topLocationId;
    param.categoryId = categoryId;
    return param;
}

@end
