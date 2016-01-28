//
//  UIViewController+COAdditions.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-13.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIViewController+COAdditions.h"

@implementation UIViewController (COAdditions)

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)dismissCurrentViewController {
    [self dismissCurrentViewController:nil];
}

- (void)dismissCurrentViewController:(CO_BLOCK_VOID)completion {
    [self dismissCurrentViewController:completion animatedFlag:YES];
}

- (void)dismissCurrentViewController:(CO_BLOCK_VOID)completion animatedFlag:(BOOL)animatedFlag {
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:animatedFlag];
        
    } else {
        
        [self.presentingViewController dismissViewControllerAnimated:animatedFlag completion:^{
                        
            if (completion) {
                completion();
            }
        }];
    }
}

- (void)dismissMailCurrentViewController:(CO_BLOCK_VOID)completion animatedFlag:(BOOL)animatedFlag {
    
//    UIViewController *rootVc = self.presentingViewController;
//    
//    NSLog(@"rootVc = %@",rootVc);
//    [self dismissModalViewControllerAnimated:YES];
    
//    [rootVc dismissViewControllerAnimated:YES completion:^{
//        NSLog(@"%@",self.presentingViewController);
//    }];
    
    [self.presentingViewController.navigationController dismissViewControllerAnimated:animatedFlag completion:^{
        
//        UIViewController *rootVc = self
        
        NSLog(@"self.presentingViewController == %@",self.presentingViewController);
        
        if (self.presentingViewController.navigationController) {
            [self.presentingViewController.navigationController popViewControllerAnimated:animatedFlag];
        } else {
            [self.presentingViewController dismissViewControllerAnimated:animatedFlag completion:^{
                if (completion) {
                    completion();
                }
            }];
        }
    }];

}

- (BOOL)co_isVisible {
    // check isViewLoaded first to avoid accidently loading the view
    return [self isViewLoaded] && self.view.window;
}

#pragma mark - notification center

- (void)co_removeFromNotificationCenter {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - keyboard notification

- (void)co_registerKeyboardNotification {
    [self co_registerKeyboardNotificationOnWillShow:@selector(co_onWillShowKeyboard:) onWillHide:@selector(co_onWillHideKeyboard:) onDidShow:@selector(co_onDidShowKeyboard:) onDidHide:@selector(co_onDidHideKeyboard:) onWillChangeFrame:@selector(co_onKeyboardWillChangeFrame:) onDidChangeFrame:@selector(co_onKeyboardDidChangeFrame:)];
}

- (void)co_registerKeyboardNotificationOnWillShow:(SEL)onWillShowCallback onWillHide:(SEL)onWillHideCallback onDidShow:(SEL)onDidShowCallback onDidHide:(SEL)onDidHideCallback onWillChangeFrame:(SEL)onWillChangeFrameCallback onDidChangeFrame:(SEL)onDidChangeFrameCallback {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:onWillShowCallback
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:onWillHideCallback
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:onDidShowCallback
                                             name:UIKeyboardDidShowNotification
                                           object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:onDidHideCallback
                                             name:UIKeyboardDidHideNotification
                                           object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:onWillChangeFrameCallback name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:onDidChangeFrameCallback name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)co_onKeyboardWillChangeFrame:(NSNotification *)noti {
    CGRect beginFrame, endFrame;
    beginFrame = [[noti.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    endFrame = [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self co_onKeyboardWillChangeFrame:noti kbBeginFrame:beginFrame kbEndFrame:endFrame];
}

- (void)co_onKeyboardDidChangeFrame:(NSNotification *)noti {
    CGRect beginFrame, endFrame;
    beginFrame = [[noti.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    endFrame = [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self co_onKeyboardDidChangeFrame:noti kbBeginFrame:beginFrame kbEndFrame:endFrame];
}

- (void)co_onKeyboardWillChangeFrame:(NSNotification *)noti kbBeginFrame:(CGRect)kbBeginFrame kbEndFrame:(CGRect)kbEndFrame {}

- (void)co_onKeyboardDidChangeFrame:(NSNotification *)noti kbBeginFrame:(CGRect)kbBeginFrame kbEndFrame:(CGRect)kbEndFrame {}


- (void)co_onWillShowKeyboard:(NSNotification *)noti {
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    [self co_onWillShowKeyboard:noti keyboardBounds:keyboardBounds];
//    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
}

- (void)co_onWillShowKeyboard:(NSNotification *)noti keyboardBounds:(CGRect)keyboardBounds {}

- (void)co_onWillHideKeyboard:(NSNotification *)noti {}

- (void)co_onDidShowKeyboard:(NSNotification *)noti {}

- (void)co_onDidHideKeyboard:(NSNotification *)noti {}

@end
