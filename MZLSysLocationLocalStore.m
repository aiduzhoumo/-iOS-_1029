//
//  MZLSysLocationLocalStore.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-10-11.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLSysLocationLocalStore.h"
#import "COStringWithPinYin.h"
#import "YTKKeyValueStore.h"
#import "MZLModelSystemLocation.h"
#import "MZLSharedData.h"

#define MZL_SYS_LOCATION_LOCAL_STORE @"sysLoc.db"
#define MZL_SYS_LOCATION_LOCAL_TABLE @"MZL_SYS_LOC"

@implementation MZLSysLocationLocalStore

+ (void)saveSysLocations:(NSArray *)sysLocations {
    if (sysLocations.count > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            YTKKeyValueStore *store = [self store];
            [store clearTable:MZL_SYS_LOCATION_LOCAL_TABLE];
            NSMutableArray *locationsWithPinyin = [NSMutableArray array];
            for (MZLModelSystemLocation *location in sysLocations) {
                COStringWithPinYin *pinyin = [COStringWithPinYin instanceFromString:location.name];
                [store putObject:[pinyin toDictionary] withId:pinyin.str intoTable:MZL_SYS_LOCATION_LOCAL_TABLE];
                [locationsWithPinyin addObject:pinyin];
            }
            [MZLSysLocationLocalStore closeStore];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MZLSharedData setAllLocations:locationsWithPinyin];
                [COPreferences setUserPreference:[NSDate date] forKey:MZL_KEY_CACHED_SYSLOC_UPDATE_TIME];
            });
        });
    }
}

+ (NSArray *)readSysLocations {
    YTKKeyValueStore *store = [self store];
    NSArray *resultSets = [store getAllItemsFromTable:MZL_SYS_LOCATION_LOCAL_TABLE];
    NSMutableArray *result = [NSMutableArray array];
    for (YTKKeyValueItem *item in resultSets) {
        COStringWithPinYin *pinyin = [COStringWithPinYin instanceFromDictionary:(NSDictionary *)item.itemObject];
        [result addObject:pinyin];
    }
    return result;
}

static YTKKeyValueStore *_store;

+ (YTKKeyValueStore *)store {
    if (! _store) {
        _store = [[YTKKeyValueStore alloc] initDBWithName:MZL_SYS_LOCATION_LOCAL_STORE];
        [_store createTableWithName:MZL_SYS_LOCATION_LOCAL_TABLE];
    }
    return _store;
}

+ (void)closeStore {
    [_store close];
    _store = nil;
}

@end
