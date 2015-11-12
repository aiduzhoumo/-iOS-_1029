//
//  MZLTabBarViewController.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-6-11.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZLTabBarViewController : UITabBarController<UITabBarDelegate, UITabBarControllerDelegate>

- (void)showMzlTabBar:(BOOL)flag animatedFlag:(BOOL)animatedFlag;

- (void)toExploreTab;

- (void)toMyTab;

@end
