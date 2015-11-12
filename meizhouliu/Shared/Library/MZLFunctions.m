//
//  MZLFunctions.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-8.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFunctions.h"
#import "COPreferences.h"
#import "MZLModelLocationBase.h"
#import "MZLSharedData.h"
#import "NSString+COPinYin4ObjcAddition.h"
#import "COStringWithPinYin.h"
#import "NSString+COValidation.h"
#import "MZLSysLocationLocalStore.h"
#import "MZLAppNotices.h"
#import "MZLModelLocationDetail.h"

NSString *formatTags(NSString *tags, NSString *separator) {
    if (isEmptyString(tags)) {
        return tags;
    }
    NSArray *tagsArray = [tags split:@" "];
    return [tagsArray componentsJoinedByString:separator];
}

NSArray *generateTags(NSString *tags) {
    return [tags split:@" "];
}

#pragma mark - cities and locations

NSString *cityFromGPSLocation(NSString *gpsLocation) {
    // 从定位返回的可能是英文(操作系统为英文)
    if ([gpsLocation isAllEnglishLetters]) {
        NSString *lowercase = [gpsLocation lowercaseString];
        NSDictionary *pinyinDict = [MZLSharedData cityPinyinDict];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@", lowercase];
        NSArray *filteredKeys = [[pinyinDict allKeys] filteredArrayUsingPredicate:pred];
        if (filteredKeys.count > 0) {
            NSString *key = filteredKeys[0];
            return pinyinDict[key];
        }
    }
    return gpsLocation;
}

NSDictionary *cityPinyinDictionary() {
    NSArray *cities = [MZLSharedData allCities];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSString *city in cities) {
        NSString *cityPinyin = [city co_toPinYin];
        [result setObject:city forKey:[cityPinyin lowercaseString]];
    }
    return result;
}

NSArray *allCities() {
    // read from cache first
    NSString *cityList = [COPreferences getUserPreference:MZL_KEY_CACHED_CITYLIST];
    if (! cityList) {
        cityList = co_readFileFromBundle(@"all_cities", @"txt");
    }
    return [cityList split:@" "];
}

NSArray *allLocations() {
    NSString *locationsStr = co_readFileFromBundle(@"all_locations", @"txt");
    NSArray *locations = [locationsStr split:@" "];
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *location in locations) {
        COStringWithPinYin *pinyinStr = [COStringWithPinYin instanceFromString:location];
        [result addObject:pinyinStr];
    }
    return result;
}

//void refreshSystemLocations() {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSArray *locations = [MZLSysLocationLocalStore readSysLocations];
//        if (locations.count == 0) {
//            locations = allLocations();
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MZLSharedData setAllLocations:locations];
//        });
//    });
//}

#pragma mark - location related

BOOL isCoordinateValid(CLLocationCoordinate2D point) {
    return !(point.latitude == 0.0 && point.longitude == 0.0);
}

BOOL isLocationCoordinateValid(MZLModelLocationDetail *location) {
    return isCoordinateValid(CLLocationCoordinate2DMake(location.latitude, location.longitude));
}

BOOL hasSubStr(NSString *string, NSString *subStr) {
    return [string rangeOfString:subStr].length > 0;
}

/** whether string has any character in charaters */
BOOL hasAnyCharacter(NSString *string, NSString *characters) {
    for (int i = 0; i < characters.length; i ++) {
        NSString *subStr = [characters substringWithRange:NSMakeRange(i, 1)];
        if (hasSubStr(string, subStr)) {
            return true;
        }
    }
    return false;
}

MKCoordinateSpan coordinateSpanFromLocation(MZLModelLocationBase *location) {
    NSString *address = location.address;
    if (isEmptyString(address)) {
        return MKCoordinateSpanMake(MZL_MAP_AUTO_ZOOM_DEFAULT, MZL_MAP_AUTO_ZOOM_DEFAULT);
    }
    
    // 如果是风景区则使用风景区的缩放比例
    if (location.isViewPoint) {
        return  MKCoordinateSpanMake(MZL_MAP_AUTO_ZOOM_VIEWPOINT, MZL_MAP_AUTO_ZOOM_VIEWPOINT);
    }
    
    // Sample address - (1) 杭州市临安市大峡谷镇西坑村11号; (2)温州市平阳县南麂山列岛
    
    BOOL hasCity = hasAnyCharacter(address, @"市");
    
    BOOL hasCounty = hasAnyCharacter(address, @"县区镇");
    
    BOOL hasVillage = hasAnyCharacter(address, @"村岛");
    
    BOOL hasHouseNumber = hasAnyCharacter(address, @"路街号");
    
    // 按范围从小到大依次匹配
    if (hasHouseNumber) {
        return  MKCoordinateSpanMake(MZL_MAP_AUTO_ZOOM_VERY_LARGE, MZL_MAP_AUTO_ZOOM_VERY_LARGE);
    } else if (hasVillage) {
        return MKCoordinateSpanMake(MZL_MAP_AUTO_ZOOM_LARGE, MZL_MAP_AUTO_ZOOM_LARGE);
    } else if (hasCounty) {
        return MKCoordinateSpanMake(MZL_MAP_AUTO_ZOOM_MIDDLE, MZL_MAP_AUTO_ZOOM_MIDDLE);
    } else if (hasCity) {
        return MKCoordinateSpanMake(MZL_MAP_AUTO_ZOOM_SMALL, MZL_MAP_AUTO_ZOOM_SMALL);
    }
    
//    if (hasCity) {
//        if (hasCounty) {
//            if (hasVillage) {
//                // 街道级别
//                return MKCoordinateSpanMake(MZL_MAP_AUTO_ZOOM_VERY_LARGE, MZL_MAP_AUTO_ZOOM_VERY_LARGE);
//            } else {
//                // 无路街村，县级别
//                return MKCoordinateSpanMake(MZL_MAP_AUTO_ZOOM_LARGE, MZL_MAP_AUTO_ZOOM_LARGE);
//            }
//        } else {
//            // 无县区镇，城市级别
//            return MKCoordinateSpanMake(MZL_MAP_AUTO_ZOOM_SMALL, MZL_MAP_AUTO_ZOOM_SMALL);
//        }
//    }
    
    return MKCoordinateSpanMake(MZL_MAP_AUTO_ZOOM_DEFAULT, MZL_MAP_AUTO_ZOOM_DEFAULT);
    
}

MKCoordinateSpan coordinateSpanAmongLocations(MZLModelLocationBase *centerLocation, NSArray *locations, CGFloat scale, BOOL isDisplayAllLocations) {
    if (locations.count <= 1) {
        return coordinateSpanFromLocation(centerLocation);
    }
    NSArray *points = [locations map:^id(id object) {
        MZLModelLocationBase *location = ((MZLModelLocationBase *)object);
        return [NSValue valueWithMKCoordinate:CLLocationCoordinate2DMake(location.latitude, location.longitude)];
    }];
    MKCoordinateSpan span =  coordinateSpanAmongPoints(CLLocationCoordinate2DMake(centerLocation.latitude, centerLocation.longitude), points, scale, isDisplayAllLocations);
    if (! isDisplayAllLocations) {
        // 高亮中心点的，再结合具体地址信息定缩放比例
        MKCoordinateSpan spanFromLocation = coordinateSpanFromLocation(centerLocation);
        // 取缩放比例较大的即值较小的
        span = spanFromLocation.latitudeDelta < span.latitudeDelta && spanFromLocation.longitudeDelta < span.longitudeDelta ? spanFromLocation : span;
    }
    return span;
}

MKCoordinateSpan coordinateSpanAmongPoints(CLLocationCoordinate2D curPoint, NSArray *points, CGFloat scale, BOOL isDisplayAllPoints) {
    if (points.count <= 1) {
        return MKCoordinateSpanMake(MZL_MAP_AUTO_ZOOM_DEFAULT, MZL_MAP_AUTO_ZOOM_DEFAULT);
    }
    NSMutableArray *latDeltas = [NSMutableArray array];
    NSMutableArray *lonDeltas = [NSMutableArray array];
    for (NSValue *value in points) {
        CLLocationCoordinate2D tempPoint = [value MKCoordinateValue];
        if(tempPoint.latitude == 0 || tempPoint.longitude == 0){
            continue;
        }
        double latDelta = curPoint.latitude - tempPoint.latitude;
        double lonDelta = curPoint.longitude - tempPoint.longitude;
        if (latDelta < 0) {
            latDelta = -latDelta;
        } else if (latDelta == 0) {
            latDelta = MZL_MAP_AUTO_ZOOM_VERY_LARGE;
        }
        if (lonDelta < 0) {
            lonDelta = -lonDelta;
        } else if (lonDelta == 0) {
            lonDelta = MZL_MAP_AUTO_ZOOM_VERY_LARGE;
        }
        [latDeltas addObject:[NSNumber numberWithDouble:latDelta]];
        [lonDeltas addObject:[NSNumber numberWithDouble:lonDelta]];
    }
    NSArray *sortedLatDeltas = [latDeltas sortedArrayUsingSelector:@selector(compare:)];
    NSArray *sortedLonDeltas = [lonDeltas sortedArrayUsingSelector:@selector(compare:)];
    double resultLatDelta, resultLonDelta;
    if (isDisplayAllPoints) { // 尽可能显示全部点，取最大偏差值，即缩放最小
        resultLatDelta = [sortedLatDeltas[sortedLatDeltas.count - 1] doubleValue];
        resultLonDelta = [sortedLonDeltas[sortedLonDeltas.count - 1] doubleValue];
    } else { // 显示当前点，缩放最大
        resultLatDelta = [sortedLatDeltas[0] doubleValue];
        resultLonDelta = [sortedLonDeltas[0] doubleValue];
    }
    return MKCoordinateSpanMake(resultLatDelta * scale, resultLonDelta *scale);
}

#pragma mark - date related functions

NSDate* dateFromString(NSString *str) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:str];
}

NSDate *yesterday() {
    NSTimeInterval ti = ([[NSDate date] timeIntervalSinceReferenceDate] - 24*3600);
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:ti];
    return date;
}

NSURL *webUrl(NSString *url) {
    // 加入参数，方便服务端判断页面请求来源
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *temp = [NSString stringWithFormat:@"%@?from_iOS=true&version=%@&machine_id=%@",url,version,[MZLSharedData appMachineId]];
    return [[NSURL alloc] initWithString:temp];
}

#pragma mark - identify bundle identifier;

BOOL isMZLProdApp() {
    return [[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.meizhouliu.ios"];
}

BOOL isMZLTestApp() {
    return [[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.meizhouliu.adhoc"];
}

#pragma mark - application badges

NSInteger appBadgeCount() {
    return [[UIApplication sharedApplication] applicationIconBadgeNumber];
}

//void decreaseAppBadge() {
//    updateAppBadge(appBadgeCount() - 1);
//}

void updateAppBadge(NSInteger badgeCount) {
    if (badgeCount < 0) {
        badgeCount = 0;
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount];
//    [MZLTabBar checkTabBarNotiHint];
}

void updateAppBadgeWithUnreadNotiCount() {
    updateAppBadge([MZLAppNotices unReadMessageCount]);
}

#pragma filter images

NSArray* imagesOfCrowd() {
    return @[@"Filter_People_Sister",@"Filter_People_Sweethearts",@"Filter_People_Friends",
             @"Filter_People_Single",@"Filter_People_Paternity",@"Filter_People_Group"];
}

NSArray* imagesOfFeature() {
    return @[@"Filter_Feature_Luxurious",@"Filter_Feature_Delicious",@"Filter_Feature_Romantic",
             @"Filter_Feature_Oldtown",@"Filter_Feature_Silent",@"Filter_Feature_Photography",@"Filter_Feature_SeaSide",@"Filter_Feature_Spring",@"Filter_Feature_Wenyi",@"Filter_Feature_Outing",@"Filter_Feature_Camping",@"Filter_Feature_Mountain"];
}
