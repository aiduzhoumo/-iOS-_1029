//
//  UIView+MBProgressHUDAdditions.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIView+MBProgressHUDAdditions.h"
#import "MBProgressHUD.h"

@implementation UIView (MBProgressHUDAdditions)

static MBProgressHUD *gProgressHUD;

- (void)showProgressIndicator:(NSString *)title message:(NSString *)message {
    [self showProgressIndicator:title message:message isUseWindowForDisplay:YES];
}

- (void)showProgressIndicator:(NSString *)title message:(NSString *)message isUseWindowForDisplay:(BOOL)flag {
    UIView *parentVw = self;
    if (flag) { // 如果能取得当前window
        UIWindow *window = self.window;
        if (! window) {
            window = globalWindow();
        }
        if (window) {
            parentVw = window;
        }
    }
    if (!gProgressHUD) {
        gProgressHUD = [[MBProgressHUD alloc]initWithView:parentVw];
        gProgressHUD.removeFromSuperViewOnHide = YES;
        gProgressHUD.dimBackground = NO;
    }
    gProgressHUD.labelText = title;
    gProgressHUD.detailsLabelText = message;
    if (! (gProgressHUD.superview == parentVw)) {
        [parentVw addSubview:gProgressHUD];
    }
    [gProgressHUD show:YES];
}


- (void)hideProgressIndicator {
    [self hideProgressIndicator:YES];
}

- (void)hideProgressIndicator:(BOOL)flag {
    [UIView hideProgressIndicator:flag];
}

+ (void)hideProgressIndicator:(BOOL)flag {
    if ([self isProgressIndicatorVisible]) {
        [gProgressHUD hide:flag];
    }
}

+ (BOOL)isProgressIndicatorVisible {
    return gProgressHUD && gProgressHUD.superview != nil;
}


@end
