//
//  COMacros.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-12.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CO_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define CO_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define iOS_VER_7_0 @"7.0"
#define iOS_VER_7_1 @"7.1"
#define iOS_VER_8_0 @"8.0"

#define CO_IPHONE6_SCREEN_WIDTH 375.0
#define CO_IPHONE6_SCREEN_HEIGHT 667.0
#define CO_IPHONE6_PLUS_SCREEN_WIDTH 414.0
#define CO_IPHONE6_PLUS_SCREEN_HEIGHT 736.0

typedef void (^ CO_BLOCK_VOID)(void);
typedef BOOL (^ CO_BLOCK_RET_BOOL)(void);
typedef id (^ CO_BLOCK_MAP)(id value);
