//
//  MZLLocationDelegate.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-6-25.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLLocationDelegate.h"
#import "MZLSharedData.h"
#import <IBMessageCenter.h>
#import "MZLLocationInfo.h"
#import <IBAlertView.h>
#import "MobClick.h"
#import "UIView+MBProgressHUDAdditions.h"

#define MZL_ERROR_DOMAIN_CORE_LOCATION @"kCLErrorDomain"

@interface MZLLocationDelegate() {
    NSNumber *_previousLocationAuthorizedStatus;
}

@end

@implementation MZLLocationDelegate

static MZLLocationDelegate *_sharedInstance;


#pragma mark - shared instance

+ (MZLLocationDelegate *)sharedInstance {
    if (! _sharedInstance) {
        _sharedInstance = [[MZLLocationDelegate alloc] init];
    }
    return _sharedInstance;
}

#pragma mark - AMapSearchDelegate

- (void)searchReGeocode:(CLLocation *)location
{
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    // 象山县经纬度 29.48 121.87
    CGFloat latitude = location.coordinate.latitude;
    CGFloat longitude = location.coordinate.longitude;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    regeoRequest.requireExtension = NO;
    AMapSearchAPI *api = [MZLSharedData aMapSearch];
    api.delegate = self;
    [api AMapReGoecodeSearch: regeoRequest];
}

- (void)onAMapReGeocodeDone {
    [MZLSharedData stopLocationTimer];
    [MZLSharedData aMapSearch].delegate = nil;
}

- (void)searchRequest:(id)request didFailWithError:(NSError *)error {
    [self onAMapReGeocodeDone];
    [self onLocationError];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    [self onAMapReGeocodeDone];
    AMapAddressComponent *addr = response.regeocode.addressComponent;
    NSString *province = addr.province;
    NSString *county = addr.district;
    NSString *city = addr.city;
    NSString *location;
    // 处理直辖市
    if ([province hasSuffix:@"市"]) {
        location = province;
    } else if ([county hasSuffix:@"县"]) { // 二级区域只关注县城
        location = county;
    } else {
        if (! isEmptyString(city)) {
            location = city;
        }
    }
    if (! location) {
        [self onLocationError];
        return;
    }    
    [MZLSharedData setCity:location];
    [self onLocationRetrieved];
}

#pragma mark - location service and delegate


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    // 当状态为不确定状态时，不开启定位，只有当状态确定时，才开始刷新位置信息
    if (status == kCLAuthorizationStatusNotDetermined) {
        _previousLocationAuthorizedStatus = @(kCLAuthorizationStatusNotDetermined);
    } else {
        if (_previousLocationAuthorizedStatus) {
            _previousLocationAuthorizedStatus = nil;
            [MZLSharedData onLocationAuthorizedStatusDetermined];
        }
    }
}

- (void)invokeGeocoder:(CLLocation *)location {
    [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_LOCATION_START_REVERSE_GEOCODER];
    [self searchReGeocode:location];
}

- (void)onLocationRetrieved {
    NSString *curCity = [MZLSharedData currentCity];
    NSString *cachedCity = [MZLSharedData cachedCity];
    
//#ifdef MZL_DEBUG
//    curCity = @"杭州";
//    cachedCity = @"杭州";
//#endif
    
    if (cachedCity && ![curCity isEqualToString:cachedCity]) {
        // alert and then decide whether to refresh list
        IBAlertView *choiceView = [IBAlertView alertWithTitle:nil message:[NSString stringWithFormat:MZL_CHOICEVIEW_ALERT_MESSAGE, curCity] dismissTitle:MZL_CHOICEVIEW_ALERT_DISMISS_TITLE okTitle:MZL_CHOICEVIEW_ALERT_OK_TITLE dismissBlock:^{
            [MobClick event:@"clickArticleListCityAlertCancel"];
            [self setSelectedCity:cachedCity];
        } okBlock:^{
            [MobClick event:@"clickArticleListCityAlertOK"];
            [self setSelectedCity:curCity];
        }];
        [choiceView show];
        [MobClick event:@"clickArticleListShowCityAlert"];
    } else {
        // 忽略缓存与定位城市相同的情况
        if (! cachedCity) {
            [self setSelectedCity:curCity];
        }
    }
}

- (void)setSelectedCity:(NSString *)city {
    [MZLSharedData setSelectedCity:city];
}

- (void)onLocationError {
    [MZLSharedData onLocationError:^{
//        // 提示手动选择
//        [UIAlertView showAlertMessage:MZL_LOCATION_SERVICES_ERROR];
        [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_LOCATION_ERROR];
    }];
}

- (void)onLocationDisabled {
    [MZLSharedData onLocationDisabled];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [MZLSharedData stopLocationService];
    [MZLSharedData onLocationAuthorized];
    CLLocation *location = locations[locations.count - 1];
    [MZLSharedData setLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    [self invokeGeocoder:location];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [MZLSharedData stopLocationService];
    [MZLSharedData stopLocationTimer];
    if ([MZL_ERROR_DOMAIN_CORE_LOCATION isEqualToString:[error domain]] && [error code] == kCLErrorDenied) { // 仅仅是“美周六”这个App定位被禁
        [self onLocationDisabled];
        return;
    }
    [self onLocationError];

}


@end
