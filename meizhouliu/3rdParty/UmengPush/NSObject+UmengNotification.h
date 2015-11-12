//
//  UmengNotification.h
//  mzl_mobile_ios
//
//  Created by race on 14/12/19.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMessage.h"

@interface NSObject (UmengNotification)

- (void)registerUmengNotification:(NSDictionary *)launchOptions;

- (void)onRegUmengNotiSuccWithDeviceToken:(NSString *)token;

- (void)onRegUmengNotiError:(NSError *)error;

@end
