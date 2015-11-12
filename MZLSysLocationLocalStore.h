//
//  MZLSysLocationLocalStore.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-10-11.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZLSysLocationLocalStore : NSObject

+ (NSArray *)readSysLocations;
+ (void)saveSysLocations:(NSArray *)sysLocations;
+ (void)closeStore;

@end
