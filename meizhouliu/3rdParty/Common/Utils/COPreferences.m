//
//  COPreferences.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-8.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "COPreferences.h"

@implementation COPreferences

+ (id)getUserPreference:(NSString *)key {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

+ (void)setUserPreference:(id)value forKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+ (void)removeUserPreference:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

+ (void)archiveUserPreference:(id<NSCoding>)data forKey:(NSString *)key {
    if (data) {
        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:data];
        [self setUserPreference:archivedData forKey:key];
    }
}

+ (id)getCodedUserPreference:(NSString *)key {
    NSData *data = [self getUserPreference:key];
    if (data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

@end
