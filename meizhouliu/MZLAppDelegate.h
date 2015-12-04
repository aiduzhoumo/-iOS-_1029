//
//  MZLAppDelegate.h
//  meizhouliu
//
//  Created by Whitman on 14-4-2.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZLAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

//@property (nonatomic, assign) BOOL isBind;

- (UIViewController *)currentVisibleViewController;
@end
