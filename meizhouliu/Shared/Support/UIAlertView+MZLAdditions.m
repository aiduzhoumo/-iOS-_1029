//
//  UIAlertView+MZLAdditions.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-8.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIAlertView+MZLAdditions.h"
#import "UIAlertView+COAdditions.h"
#import <IBAlertView.h>

@implementation UIAlertView (MZLAdditions)

+ (void) showAlertMessage:(NSString *)message {
    [self showAlertMessage:message title:MZL_MSG_ALERT_VIEW_TITLE];
}

+ (void) showAlertMessage:(NSString *)message title:(NSString *)title {
    [self showAlertMessage:message title:title cancleButtonTitle:MZL_MSG_OK];
}

+ (void) alertOnNetworkError {
    [self showAlertMessage:MZL_MSG_NETWORKFAILURE];
}

+ (void) alertOnDeleteError {
    [self showAlertMessage:MZL_MSG_DELETEFAILURE];
}

+ (void) alertOnConfigError {
    [self showAlertMessage:MZL_MSG_CONFIGFAILURE];
}

+ (void) showChoiceMessage:(NSString *)message okBlock:(CO_BLOCK_VOID)okBlock {
    [IBAlertView showAlertWithTitle:MZL_MSG_ALERT_VIEW_TITLE message:message dismissTitle:MZL_MSG_CANCLE okTitle:MZL_MSG_OK dismissBlock:^{
    } okBlock:^{
        okBlock();
    }];
}

@end
