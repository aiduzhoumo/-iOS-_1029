//
//  COPreferences.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-8.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface COPreferences : NSObject

#pragma mark Preferences
+ (id)getUserPreference:(NSString *)key;
+ (void)setUserPreference:(id)value forKey:(NSString *)key;
+ (void)removeUserPreference:(NSString *)key;
+ (void)archiveUserPreference:(id<NSCoding>)data forKey:(NSString *)key;
+ (id)getCodedUserPreference:(NSString *)key;

+ (void)setAttentionUserId:(id)value forKey:(NSString *)key;
+ (id)getAttentionUserId:(NSString *)key;
+ (void)removeAttentionUserId:(NSString *)key;
@end
