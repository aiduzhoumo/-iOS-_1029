//
//  UIViewController+COTextFieldDelegate.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-16.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIViewController+COTextFieldDelegate.h"

@implementation UIViewController (COTextFieldDelegate)

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    UITextField *nextField = (UITextField *)[self.view viewWithTag:(textField.tag) + 1];
    if (nextField) {
        [nextField becomeFirstResponder];
    }
    return YES;
}

@end
