//
//  NSObject+COAppDelegateForNotification.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-7-30.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "NSObject+COAppDelegateForNotification.h"
#import "APService.h"
#import "MZLServices.h"


@implementation NSObject (COAppDelegateForNotification)

- (void)co_registerNotification {
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)];
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
//    NSLog(@"Device token is : %@", hexToken);
    [self co_onRegNotiSuccWithDeviceToken:hexToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [self co_onRegNotiError:error];
}

- (void)co_onRegNotiSuccWithDeviceToken:(NSString *)token {
    
}

- (void)co_onRegNotiError:(NSError *)error {
    
}

@end
