//
//  MZLiVersionDelegate.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-6-17.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLiVersionDelegate.h"
#import "IBAlertView.h"

@interface MZLiVersionDelegate() {
}

@end

@implementation MZLiVersionDelegate

static MZLiVersionDelegate *_sharedInstance;

+ (MZLiVersionDelegate *)sharedInstance {
    if (! _sharedInstance) {
        _sharedInstance = [[MZLiVersionDelegate alloc] init];
    }
    return _sharedInstance;
}

#pragma mark - iVersionDelegate

- (BOOL)iVersionShouldCheckForNewVersion {
    return NO;
}

/** 不显示更新内容 */
- (BOOL)iVersionShouldDisplayCurrentVersionDetails:(NSString *)versionDetails {
    return NO;
}

- (BOOL)iVersionShouldDisplayNewVersion:(NSString *)version details:(NSString *)versionDetails {
    return NO;
}

@end
