//
//  UIViewController+MZLLocationSupport.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15/3/23.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "UIViewController+MZLLocationSupport.h"
#import "UIViewController+MZLAdditions.h"
#import <IBMessageCenter.h>

@implementation UIViewController (MZLLocationSupport)

- (void)mzl_initLocation {
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_LOCATION_UPDATED target:self action:@selector(_mzl_onLocationUpdated)];
    if (! [MZLSharedData selectedCity] && [MZLSharedData isLocationServiceRunning]) {
        // 正在获取当前地址中，等待回调
        // 该notification只针对禁掉单个“美周六”APP的情况
        [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_LOCATION_DISABLED target:self action:@selector(_mzl_onLocationError)];
        [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_LOCATION_ERROR target:self action:@selector(_mzl_onLocationError)];
        [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_LOCATION_TIMEOUT target:self action:@selector(_mzl_onLocationError)];
        [self showGetLocationProgressIndicatior];
    } else {
        // 地址已经确定(eithor from GPS or cache)或地址获取已经失败(会在调用service的时候弹出城市列表)
        [self _mzl_initLocation_LocationIdentified];
    }
}

- (void)mzl_registerUpdateLocation {
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_LOCATION_UPDATED target:self action:@selector(_mzl_onLocationUpdated)];
}

- (void)_mzl_initLocation_LocationIdentified {
}

- (void)_mzl_onLocationUpdated {
}

- (void)_mzl_onLocationError {
    // 只track一次
    [IBMessageCenter removeMessageListener:MZL_NOTIFICATION_LOCATION_DISABLED source:nil target:self];
    [IBMessageCenter removeMessageListener:MZL_NOTIFICATION_LOCATION_ERROR source:nil target:self];
    [IBMessageCenter removeMessageListener:MZL_NOTIFICATION_LOCATION_TIMEOUT source:nil target:self];

}

@end
