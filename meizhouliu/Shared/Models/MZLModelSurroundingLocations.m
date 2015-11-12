//
//  MZLModelSurroundingLocations.m
//  mzl_mobile_ios
//
//  Created by race on 15/1/5.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLModelSurroundingLocations.h"
#import "MZLModelLocationExt.h"
#import "MZLLocationInfo.h"

@implementation MZLModelSurroundingLocations

#pragma mark - handy properties

- (NSString *)address {
    return self.locationExt.address;
}

- (NSString *)introduction {
    return self.locationExt.introduction;
}

#pragma mark - override

- (NSMutableDictionary *)_toDictionary {
    NSMutableDictionary *dict = [super _toDictionary];
    [dict setKey:@"destination[name]" strValue:self.locationName];
    [dict setKey:@"destination[amap_category]" strValue:self.aMapType];
    [dict setKey:@"destination[amap_id]" strValue:self.aMapId];
    [dict setKey:@"destination[longitude]" strValue:NSStringWithFormat(@"%@", @(self.longitude))];
    [dict setKey:@"destination[latitude]" strValue:NSStringWithFormat(@"%@", @(self.latitude))];

    if (!isEmptyString(self.aMapPCode)) {
        [dict setKey:@"destination[destination_detail_attributes][province]" strValue:self.aMapPCode];
    }
    if (!isEmptyString(self.aMapCityCode)) {
        [dict setKey:@"destination[destination_detail_attributes][amap_city]" strValue:self.aMapCityCode];
    }
    if (!isEmptyString(self.address)) {
        [dict setKey:@"destination[destination_detail_attributes][address]" strValue:self.address];
    }
    return dict;
}

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
    [mapping addRelationFromPath:@"destination_detail" toProperty:@"locationExt" withMapping:[MZLModelLocationExt rkObjectMapping]];
}


+ (NSMutableArray *)attrArray {
    return [[super attrArray] addArray:@[@"latitude", @"longitude"]];
}

+ (NSMutableDictionary *)attributeDictionary {
    NSMutableDictionary *attrDict = [super attributeDictionary];
    [attrDict fromPath:@"name" toProperty:@"locationName"];
    [attrDict fromPath:@"products_count" toProperty:@"productsCount"];
    return attrDict;
}

#pragma mark - misc

- (NSString *)distanceInKm {
    MZLLocationInfo *sharedLocInfo = [MZLSharedData currentLocation];
    if (sharedLocInfo && self.latitude != 0 && self.longitude != 0) {
        CLLocation *clSharedLocation = [[CLLocation alloc] initWithLatitude:sharedLocInfo.latitude.doubleValue longitude:sharedLocInfo.longitude.doubleValue];
        CLLocation *clLocation = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
        CLLocationDistance distance = ceil([clSharedLocation distanceFromLocation:clLocation] / 1000.0);
        if (distance > 0) {
            return [NSString stringWithFormat:@"距离%dkm", (NSInteger)distance];
        }
    }
    return @"";
}

@end
