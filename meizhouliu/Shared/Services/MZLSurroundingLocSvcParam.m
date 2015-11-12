//
//  MZLSurroundingLocSvcParam.m
//  mzl_mobile_ios
//
//  Created by race on 15/1/5.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLSurroundingLocSvcParam.h"
#import "MZLLocationInfo.h"
#import "MZLPagingSvcParam.h"

@implementation MZLSurroundingLocSvcParam

- (NSMutableDictionary *)_toDictionary {
    NSMutableDictionary *dict = [super _toDictionary];
    if (! isEmptyString(self.latitude)) {
        [dict setKey:@"latitude" strValue:self.latitude];
    }
    if (! isEmptyString(self.longitude)) {
        [dict setKey:@"longitude" strValue:self.longitude];
    }
    if (! isEmptyString(self.city)) {
        [dict setKey:@"name" strValue:self.city];
    }
    if (self.pagingParam) {
        [dict addEntriesFromDictionary:[self.pagingParam toDictionary]];
    }
    [dict setKey:@"limit" intValue:5];
    return dict;
}

+ (instancetype)instanceWithCurLocation:(MZLLocationInfo *)locationInfo paging:(MZLPagingSvcParam *)pagingParam{
    MZLSurroundingLocSvcParam *param = [[MZLSurroundingLocSvcParam alloc] init];
    param.latitude = [locationInfo.latitude stringValue];
    param.longitude = [locationInfo.longitude stringValue];
    param.city = locationInfo.city;
    param.pagingParam = pagingParam;
    
    return param;
}


@end
