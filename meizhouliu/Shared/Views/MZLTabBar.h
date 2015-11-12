//
//  MZLTabBar.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-6-11.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAB_PERSONALIZED_SHORT_ARTICLES 0
#define TAB_PERSONALIZED 1
#define TAB_WRITE_SHORT_ARTICLE 2
#define TAB_EXPLORE 3
#define TAB_MY 4
#define MZLTabBarHeight 49.0

@interface MZLTabBar : UIView

+ (id)tabBarInstance:(CGSize)parentViewSize;

- (void)onTabSelected:(NSInteger)selectedIndex;


@end
