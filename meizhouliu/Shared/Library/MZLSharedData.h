//
//  MZLSharedData.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-9.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MZLLocationInfo, CLLocationManager, MZLAppUser,MZLAppNotices,AMapSearchAPI;

@interface MZLSharedData : NSObject

<<<<<<< HEAD
#pragma mark - apservice registrationID
+ (void)setAPserviceRegistrationID:(NSString *)registrationID;
+ (NSString *)apsericeregistrationID;

#pragma mark -duzoumoToken
+ (void)setAppDuZhouMoUserToken:(NSString *)string;
+ (NSString *)appDuZhouMoToken;

=======
>>>>>>> parent of d1afe84... Merge branch 'mzl_FJbranch'
#pragma mark - tags config

+ (NSArray *)allTagTypes;

#pragma mark - filter config

+ (NSArray *)selectedFilterOptions;
+ (void)setSelectedFilterOptions:(NSArray *)filterOptions;
+ (NSArray *)filterOptions;
+ (void)setFilterOptions:(NSArray *)filterOptions;

#pragma mark - login related

/** unique identifier (machine id) */
+ (NSString *)appMachineId;

+ (MZLAppUser *)appUser;
+ (void)setAppUser:(MZLAppUser *)user;
+ (BOOL)isAppUserLogined;
/** 登录后的token */
+ (NSString *)appUserAccessToken;
+ (NSInteger)appUserId;

+ (void)loadAppUserFromCache;
+ (void)clearAppUser;
+ (void)logout;

+ (void)setLoginRemind;
+ (void)clearLoginRemind;
+ (NSDate *)loginRemindDateTime;

#pragma mark - device token for notification

+ (NSString *)deviceTokenForNotification;
+ (void)setDeviceTokenForNotification:(NSString *)deviceToken;

#pragma mark - cities and locations

+ (NSArray *)allCities;
+ (void)setAllCities:(NSArray *)allCities;
+ (NSArray *)allLocations;
+ (void)setAllLocations:(NSArray *)allLocations;
+ (NSDictionary *)cityPinyinDict;
+ (void)setCityPinyinDict:(NSDictionary *)dict;
+ (void)loadSystemLocations;

#pragma mark - location related

+ (MZLLocationInfo *)currentLocation;
+ (void)setLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;
+ (void)setCity:(NSString *)city;
+ (NSString *)currentCity;

+ (NSString *)cachedCity;

+ (NSString *)selectedCity;
+ (void)setSelectedCity:(NSString *)selectedCity;

+ (void)loadLocationFromCache;

#pragma mark - location service
+ (void)startLocationService;
+ (void)stopLocationService;
+ (BOOL)isLocationServiceRunning;
+ (CLLocationManager *)locationManager;
//+ (CLGeocoder *)geoCoder;
+ (AMapSearchAPI *)aMapSearch;
+ (void)setSearchWithApiKey:(NSString *)key ;
+ (void)stopGeoService;
+ (void)stopAllLocationService;
+ (void)stopLocationTimer;
+ (void)onLocationError:(CO_BLOCK_VOID)block;

#pragma mark - location service authorization related
+ (void)onLocationAuthorizedStatusDetermined;
+ (void)onLocationAuthorized;
+ (void)onLocationDisabled;
+ (BOOL)shouldIgnoreLocationDisabledError;
+ (void)setShouldIgnoreLocationDisabledError:(BOOL)flag;

#pragma mark - youmeng adurl 

+ (NSString *)youmengAdUrl;
+ (void)setYoumengAdUrl:(NSString *)adUrl;

//#pragma mark - sina tencent token
//+ (NSString *)wbtoken;
//+ (void)setWbtoken:(NSString *)wbtoken;
//+ (NSString *)wbUserIdentifier;
//+ (void)setWbUserIdentifier:(NSString *)wbUserIdentifier;
//+ (NSString *)qqtoken;
//+ (void)setQqtoken:(NSString *)qqtoken;
//+ (NSString *)openId;
//+ (void)setOpenId:(NSString *)openId;
//+ (NSDate *)qqExpirationDate;
//+ (void)setQqexpirationDate:(NSDate *)expirationDate;
#pragma mark - apns info

+ (BOOL)hasApsInfo;
+ (NSDictionary *)apsInfo;
+ (void)setApnsInfo:(NSDictionary *)info;

<<<<<<< HEAD
+ (void)setApnsInfoForNotification:(NSDictionary *)info;
+ (NSDictionary *)getApnsInfoForNotification;
+ (void)removeApnsinfoForNotification;


#pragma mark - attentionUserId 
+ (NSArray *)attentionIdsArr;
+ (void)setAttentionIdsArr:(NSArray *)attentionIdsArr;
+ (void)removeIdFromAttentionIds:(NSString *)Id;
+ (void)addIdIntoAttentionIds:(NSString *)Id;
+ (void)addIdArrayIntoAttentionIds:(NSArray *)IdArr;
+ (void)removeAllIdsFromAttentionIds;
=======
>>>>>>> parent of d1afe84... Merge branch 'mzl_FJbranch'
//#pragma mark - misc settings
//
//+ (BOOL)shouldPopupFiltersOnAppStartup;
//+ (void)setPopupFiltersOnAppStartup:(BOOL)flag;

//#pragma mark - notices
//+ (MZLAppNotices *)appNotices;
//+ (void)setAppNotices:(MZLAppNotices *)notices;
//+ (void)loadNoticesFromCache;
//+ (void)clearAppNotices;

@end
