//
//  UIViewController+MZLiVersionSupport.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-11-25.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIViewController+MZLiVersionSupport.h"
#import "MZLiVersionDelegate.h"
#import "MZLServices.h"

@interface iVersionDelegateForMZL : NSObject <iVersionDelegate>

@end

@implementation iVersionDelegateForMZL

#pragma mark - iVersion delegate

/** 不显示更新内容 */
- (BOOL)iVersionShouldDisplayCurrentVersionDetails:(NSString *)versionDetails {
    return NO;
}

- (BOOL)iVersionShouldDisplayNewVersion:(NSString *)version details:(NSString *)versionDetails {
    if ([versionDetails isEqualToString:@"YES"]) { // 强制下载
        [iVersion sharedInstance].remindButtonLabel = @"";
        [iVersion sharedInstance].ignoreButtonLabel = @"";
    }
    return YES;
}

@end

@implementation UIViewController (MZLiVersionSupport)

- (id<iVersionDelegate>)versionDelegate:(BOOL)dummyFlag {
    static id<iVersionDelegate> _versionDelegate;
    if (dummyFlag) {
        // 防止version弹框，设置一个不会弹框的delegate
        _versionDelegate = [[MZLiVersionDelegate alloc] init];
    } else {
        _versionDelegate = [[iVersionDelegateForMZL alloc] init];
    }
    return _versionDelegate;
}

- (BOOL)mzl_shouldCheckVersion {
    iVersion *version = [iVersion sharedInstance];
//    version.appStoreID = 0;
//    version.lastChecked = nil;
//    version.lastReminded = nil;
//    version.ignoredVersion = nil;
    return [version shouldCheckForNewVersion];
}

- (void)mzl_checkVersion {
    iVersion *version = [iVersion sharedInstance];
    version.updateAvailableTitle = MZL_IVERSION_ALERT_TITLE;
    version.updateAvailableDetail = MZL_IVERSION_ALERT_MESSAGE;
    version.downloadButtonLabel = MZL_IVERSION_CHOICE_DOWNLOAD;
    version.remindButtonLabel = MZL_IVERSION_CHOICE_REMIND;
    version.ignoreButtonLabel = MZL_IVERSION_CHOICE_IGNORE;
    version.remoteVersionsPlistURL = [MZLServices versionPlistUrl];
    version.delegate = [self versionDelegate:NO];
    [version checkForNewVersion];
}

- (void)mzl_checkVersionIfNecessary {
    if ([self mzl_shouldCheckVersion]) {
        [self mzl_checkVersion];
    }
}

- (void)mzl_resetVersionDelegate {
    iVersion *version = [iVersion sharedInstance];
    version.delegate = [self versionDelegate:YES];
}

@end
