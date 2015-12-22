//
//  MZLSharedData.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-9.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLSharedData.h"
#import "MZLLocationInfo.h"
#import "MZLAppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "MZLLocationDelegate.h"
#import <IBMessageCenter.h>
#import "MZLServices.h"
#import "MZLModelUser.h"
#import "MZLModelAccessToken.h"
#import "MZLAppUser.h"
#import "MZLAppNotices.h"
//#import "TencentOpenAPI/TencentOAuth.h"
#import <ShareSDK/ShareSDK.h>
#import "MZLModelFilterType.h"
#import "MZLModelFilterItem.h"
#import "UIView+MBProgressHUDAdditions.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import "MZLSysLocationLocalStore.h"
#import "MZLModelTagType.h"

@implementation MZLSharedData

#pragma mark - tags config

+ (NSArray *)allTagTypes {
    static NSArray *tagTypes;
    if (! tagTypes || tagTypes.count == 0) {
        // 从cache中加载
        tagTypes = [MZLModelTagType cachedTagTypes];
        if (! tagTypes || tagTypes.count == 0) {
            NSMutableArray *temp = [NSMutableArray array];
            MZLModelTagType *type = [MZLModelTagType tagTypeWithName:@"人群" tagsStrArray:@[@"闺蜜", @"情侣", @"朋友"]];
            [temp addObject:type];
            type = [MZLModelTagType tagTypeWithName:@"特征" tagsStrArray:@[@"美食", @"浪漫", @"清静"]];
            [temp addObject:type];
            return temp;
        }
    }
    return tagTypes;
}


#pragma mark - filter config

static NSArray *_mzlSelectedFilterOptions;
static NSArray *_mzlFilterOptions;

+ (NSArray *)selectedFilterOptions {
    return _mzlSelectedFilterOptions;
}

+ (void)setSelectedFilterOptions:(NSArray *)filterOptions {
    _mzlSelectedFilterOptions = filterOptions;
}

+ (NSArray *)filterOptions {
    if (! _mzlFilterOptions) {
        _mzlFilterOptions = [COPreferences getCodedUserPreference:MZL_KEY_CACHED_FILTER_OPTIONS];
        if (! _mzlFilterOptions) {
            _mzlFilterOptions = [MZLModelFilterType initialFilterTypes];
        }
        [MZLModelFilterType bindFilterItemTypeAndImage:_mzlFilterOptions];
    }
    return _mzlFilterOptions;
}

+ (void)setFilterOptions:(NSArray *)filterOptions {
    _mzlFilterOptions = filterOptions;
    [MZLModelFilterType bindFilterItemTypeAndImage:_mzlFilterOptions];
    [COPreferences archiveUserPreference:filterOptions forKey:MZL_KEY_CACHED_FILTER_OPTIONS];
}

#pragma mark - login/logout related

static NSString *_appMachineId;
static MZLModelUser *_mzlUser;
static MZLModelAccessToken *_mzlToken;
static MZLAppUser *_mzlAppUser;

/** unique identifier (machine id) */
+ (NSString *)appMachineId {
    if (! _appMachineId) {
        NSString *appMachineIdFromCache = [COPreferences getUserPreference:MZL_KEY_CACHED_APP_MACHINE_ID];
        if (! appMachineIdFromCache) {
            _appMachineId = generateUDID();
            [COPreferences setUserPreference:_appMachineId forKey:MZL_KEY_CACHED_APP_MACHINE_ID];
        } else {
            _appMachineId = appMachineIdFromCache;
        }
    }
    return _appMachineId;
}

+ (MZLAppUser *)appUser {
    if (! _mzlAppUser) {
        _mzlAppUser = [[MZLAppUser alloc] init];
    }
    return _mzlAppUser;
}

+ (void)setAppUser:(MZLAppUser *)user {
    _mzlAppUser = user;
    [_mzlAppUser saveInPreference];
}

+ (BOOL)isAppUserLogined {
    return [_mzlAppUser isLogined];
}

+ (NSInteger)appUserId {
    return _mzlAppUser.user.identifier;
}

+ (NSString *)appUserAccessToken {
    return _mzlAppUser.token.token;
}

+ (void)logout {
    if ([_mzlAppUser isLogined]) {
        if (_mzlAppUser.loginType == MZLLoginTypeSinaWeibo) {
            [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
        }
        [MZLAppUser removeUserFromPreference];
        _mzlAppUser = nil;
        [MZLAppNotices clearMessages];
        [self clearLoginRemind];
        [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_LOGOUT];
    }
}

+ (void)loadAppUserFromCache {
    _mzlAppUser = [MZLAppUser loadUserFromPreference];
}

+ (void)clearAppUser {
    [MZLAppUser removeUserFromPreference];
    _mzlAppUser = nil;
}

+ (void)setLoginRemind {
    NSDate *date = [NSDate date];
    [COPreferences setUserPreference:date forKey:MZL_KEY_CACHED_DATETIME_REMIND_LOGIN];
}

+ (void)clearLoginRemind {
    [COPreferences removeUserPreference:MZL_KEY_CACHED_DATETIME_REMIND_LOGIN];
}

+ (NSDate *)loginRemindDateTime {
    return [COPreferences getUserPreference:MZL_KEY_CACHED_DATETIME_REMIND_LOGIN];
}

#pragma mark - device token for notification

+ (NSString *)deviceTokenForNotification {
    return [COPreferences getUserPreference:MZL_KEY_CACHED_NOTIFICATION_DEVICE_TOKEN];
}

+ (void)setDeviceTokenForNotification:(NSString *)deviceToken {
    [COPreferences setUserPreference:deviceToken forKey:MZL_KEY_CACHED_NOTIFICATION_DEVICE_TOKEN];
}

#pragma mark - cities and locations

static NSArray *_allCities;
static NSArray *_allLocations;
static NSDictionary *_cityPinyinDict;

+ (NSArray *)allCities {
    if (! _allCities) {
        _allCities = allCities();
    }
    return _allCities;
}

+ (void)setAllCities:(NSArray *)allCities {
    _allCities = allCities;
}

+ (NSArray *)allLocations {
    if (! _allLocations) {
        _allLocations = [NSArray array];
    }
    return _allLocations;
}

+ (void)setAllLocations:(NSArray *)allLocations {
    _allLocations = allLocations;
}

+ (NSDictionary *)cityPinyinDict {
    if (! _cityPinyinDict) {
        _cityPinyinDict = cityPinyinDictionary();
    }
    return _cityPinyinDict;
}

+ (void)setCityPinyinDict:(NSDictionary *)dict {
    _cityPinyinDict = dict;
}

+ (void)loadSystemLocations {
    NSArray *locations = [MZLSysLocationLocalStore readSysLocations];
    if (locations.count > 0) {
        [MZLSharedData setAllLocations:locations];
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *locationsFromBundleFile = allLocations();
        dispatch_async(dispatch_get_main_queue(), ^{
            [MZLSharedData setAllLocations:locationsFromBundleFile];
        });
    });
}

#pragma mark - location info related

static MZLLocationInfo *_currentLocation;
static NSString *_selectedCity;

+ (MZLLocationInfo *)currentLocation {
    if (! _currentLocation) {
        _currentLocation = [[MZLLocationInfo alloc] init];
    }
    return _currentLocation;
}

+ (void)setLatitude:(CGFloat)latitude longitude:(CGFloat)longitude {
    MZLLocationInfo *temp = [self currentLocation];
    temp.latitude = @(latitude);
    temp.longitude = @(longitude);
}

+ (void)setCity:(NSString *)city {
    MZLLocationInfo *temp = [self currentLocation];
    temp.city = city;
}

+ (NSString *)currentCity {
    return [self currentLocation].city;
}

+ (void)cacheLocation:(MZLLocationInfo *)locationInfo {
    [COPreferences archiveUserPreference:locationInfo forKey:MZL_KEY_CACHED_LOCATION];
}

+ (void)cacheCity:(NSString *)city {
    MZLLocationInfo *locationInfo = [[MZLLocationInfo alloc] init];
    locationInfo.city = city;
    [self cacheLocation:locationInfo];
}

+ (MZLLocationInfo *)cachedLocation {
    return [COPreferences getCodedUserPreference:MZL_KEY_CACHED_LOCATION];
}

+ (NSString *)cachedCity {
    return [self cachedLocation].city;
}

+ (NSString *)selectedCity {
    return  _selectedCity;
}

+ (void)setSelectedCity:(NSString *)selectedCity {
    if (! [selectedCity isEqualToString:_selectedCity]) {
        [MZLServices recordUserLocation:selectedCity];
        [self cacheCity:selectedCity];
    }
    _selectedCity = selectedCity;
    // 无论前后城市相同与否都需要进行相关数据刷新
    [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_LOCATION_UPDATED];
}

+ (void)loadLocationFromCache {
    _selectedCity = [self cachedCity];
}

#pragma mark - location service 

static CLLocationManager *_locationManager;
static NSTimer *_locationTimer;
//static CLGeocoder *_geocoder;
static AMapSearchAPI *_aMapSearch;

+ (CLLocationManager *)locationManager {
    if (! _locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        _locationManager.delegate = [MZLLocationDelegate sharedInstance];
    }
    return _locationManager;
}

+ (AMapSearchAPI *)aMapSearch {
    return _aMapSearch;
}

+ (void)setSearchWithApiKey:(NSString *)key {
    _aMapSearch = [[AMapSearchAPI alloc] initWithSearchKey:key Delegate:nil];
}

//+ (CLGeocoder *)geoCoder {
//    if (! _geocoder) {
//        _geocoder = [[CLGeocoder alloc] init];
//    }
//    return _geocoder;
//}

+ (void)startLocationService {
    if (! [CLLocationManager locationServicesEnabled]) {
        [self onLocationDisabled];
        return;
    }
    [self stopLocationTimer];
    MZLLocationDelegate *delegate = [MZLLocationDelegate sharedInstance];
    [self locationManager].delegate = delegate;
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        // for iOS 8 and above
        if ([[self locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [[self locationManager] requestWhenInUseAuthorization];
        } else {
            [[self locationManager] startUpdatingLocation];
        }
    } else {
        [self onLocationAuthorizedStatusDetermined];
    }
}

+ (void)onLocationTimerTimeout:(NSTimer *)timer {
    _locationTimer = nil;
    [self stopAllLocationService];
    [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_LOCATION_TIMEOUT];
}

+ (void)onLocationError:(CO_BLOCK_VOID)block {
    [UIView hideProgressIndicator:NO];
    // 仅当没有选择城市时调用block,处理错误逻辑
    if (! [MZLSharedData selectedCity]) {
        if (block) {
            block();
        }
    }
}

+ (void)stopLocationTimer {
    if (_locationTimer) {
        [_locationTimer invalidate];
        _locationTimer = nil;
    }
}

+ (void)stopLocationService {
    [[self locationManager] stopUpdatingLocation];
    [self locationManager].delegate = nil;
}

+ (void)stopGeoService {
    _aMapSearch.delegate = nil;
}

+ (void)stopAllLocationService {
    [self stopLocationService];
    [self stopGeoService];
}

+ (BOOL)isLocationServiceRunning {
    // 处于定位或地址解析都认为是地址服务都在运行
    return ([self locationManager].delegate != nil || _aMapSearch.delegate != nil);
}

#pragma mark - location service authorization related

static BOOL _shouldIgnoreLocationDisabledError = NO;

+ (BOOL)shouldIgnoreLocationDisabledError {
    return _shouldIgnoreLocationDisabledError;
}

+ (void)setShouldIgnoreLocationDisabledError:(BOOL)flag {
    _shouldIgnoreLocationDisabledError = flag;
}

+ (void)onLocationDisabled {
    // 同locationError统一处理，显示精选文章列表如果没有目的地，自动弹出城市选择列表
//    [self onLocationError:^{
//        if (! [self shouldIgnoreLocationDisabledError]) {
//            [self setShouldIgnoreLocationDisabledError:YES];
//            [UIAlertView showAlertMessage:MZL_LOCATION_SERVICES_DISABLED_ERROR];
//            [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_LOCATION_DISABLED];
//        }
//    }];
}

+ (void)onLocationAuthorized {
    [MZLSharedData setShouldIgnoreLocationDisabledError:NO];
}

+ (void)onLocationAuthorizedStatusDetermined {
    // 用户允许location service或拒绝
    [[self locationManager] startUpdatingLocation];
    _locationTimer = [NSTimer scheduledTimerWithTimeInterval:MZL_DEFAULT_TIMEOUT target:self selector:@selector(onLocationTimerTimeout:) userInfo:nil repeats:NO];
}

#pragma mark - youmeng adurl

static NSString *_youmengAdUrl;

+ (NSString *)youmengAdUrl {
    return _youmengAdUrl;
}

+ (void)setYoumengAdUrl:(NSString *)adUrl {
    _youmengAdUrl = adUrl;
}

#pragma mark - apns info

static NSDictionary *_info;

+ (BOOL)hasApsInfo {
    return _info != nil;
}

+ (NSDictionary *)apsInfo {
    return _info;
}

+ (void)setApnsInfo:(NSDictionary *)info {
    if (info) {
        _info = [[NSDictionary alloc] initWithDictionary:info];
    } else {
        _info = nil;
    }
}

+ (void)loadAppUserBindInfoFromCache {


}

+ (void)setApnsInfoForNotification:(NSDictionary *)info {
    [COPreferences setUserPreference:info forKey:@"JPushInfo"];
}

+ (NSDictionary *)getApnsInfoForNotification {
   return [COPreferences getUserPreference:@"JPushInfo"];
}

+ (void)removeApnsinfoForNotification {
    [COPreferences removeUserPreference:@"JPushInfo"];
}
@end
