//
//  UIAlertView+COAdditions.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-8.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIAlertView+COAdditions.h"

@implementation UIAlertView (COAdditions)

+ (void) showAlertMessage:(NSString *)message title:(NSString *)title cancleButtonTitle:(NSString *)cancelButtonTitle {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    [alertView show];
}


@end
