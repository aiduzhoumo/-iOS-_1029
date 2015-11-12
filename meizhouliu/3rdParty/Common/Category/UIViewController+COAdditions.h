//
//  UIViewController+COAdditions.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-13.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (COAdditions)

- (void)dismissKeyboard;
- (void)dismissCurrentViewController;
- (void)dismissCurrentViewController:(CO_BLOCK_VOID)completion;
- (void)dismissCurrentViewController:(CO_BLOCK_VOID)completion animatedFlag:(BOOL)animatedFlag;

- (BOOL)co_isVisible;

- (void)co_removeFromNotificationCenter;

- (void)co_registerKeyboardNotification;
//- (void)co_registerKeyboardNotificationOnWillShow:(SEL)onWillShowCallback onWillHide:(SEL)onWillHideCallback;
- (void)co_onWillShowKeyboard:(NSNotification *)noti keyboardBounds:(CGRect)keyboardBounds;
- (void)co_onKeyboardWillChangeFrame:(NSNotification *)noti kbBeginFrame:(CGRect)kbBeginFrame kbEndFrame:(CGRect)kbEndFrame;
- (void)co_onKeyboardDidChangeFrame:(NSNotification *)noti kbBeginFrame:(CGRect)kbBeginFrame kbEndFrame:(CGRect)kbEndFrame;
- (void)co_onWillHideKeyboard:(NSNotification *)noti;
- (void)co_onDidShowKeyboard:(NSNotification *)noti;
- (void)co_onDidHideKeyboard:(NSNotification *)noti;

@end
