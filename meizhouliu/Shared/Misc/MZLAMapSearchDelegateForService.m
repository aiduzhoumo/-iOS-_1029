//
//  MZLAMapSearchDelegateForService.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15/4/23.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLAMapSearchDelegateForService.h"
#import "MZLModelSurroundingLocations.h"
#import "MZLModelLocationExt.h"

@implementation MZLAMapSearchDelegateForService

+ (instancetype)sharedInstance {
    static MZLAMapSearchDelegateForService *instance;
    if (! instance) {
        instance = [[MZLAMapSearchDelegateForService alloc] init];
    }
    return instance ;
}

- (void)searchRequest:(id)request didFailWithError:(NSError *)error {
    [MZLSharedData aMapSearch].delegate = nil;
    if (self.svcErrorBlock) {
        self.svcErrorBlock(error);
        self.svcErrorBlock = nil;
    }
}

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response {
    [MZLSharedData aMapSearch].delegate = nil;
    if (self.svcSuccBlock) {
        NSMutableArray *models = co_emptyMutableArray();
        for (AMapPOI *p in response.pois) {
            MZLModelSurroundingLocations *location = [[MZLModelSurroundingLocations alloc] init];
            location.aMapId = p.uid;
            location.aMapType = p.type;
            location.aMapPCode = p.pcode;
            location.aMapCityCode = p.citycode;
            location.locationName = p.name;
            MZLModelLocationExt *locationExt = [[MZLModelLocationExt alloc] init];
            locationExt.address = p.address;
            location.latitude = p.location.latitude;
            location.longitude = p.location.longitude;
            location.locationExt = locationExt;
            [models addObject:location];
        }
        self.svcSuccBlock(models);
        self.svcSuccBlock = nil;
    }
}

@end
