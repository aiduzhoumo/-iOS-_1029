//
//  NSObject+COAppDelegateForNotification.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-7-30.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (COAppDelegateForNotification) <UIApplicationDelegate>

- (void)co_registerNotification;

- (void)co_onRegNotiSuccWithDeviceToken:(NSString *)token;
- (void)co_onRegNotiError:(NSError *)error;

@end
