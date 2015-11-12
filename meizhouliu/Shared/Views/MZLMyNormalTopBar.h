//
//  MZLMyNormalTopBar.h
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-12.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MZLTopBarHeight 50.0
#define MZL_MY_ARTICLE_INDEX 1
#define MZL_MY_WANT_INDEX 2
#define MZL_MY_FAVOR_INDEX 3
#define MZL_MY_NOTIFICATION_INDEX 4

@protocol MZLMyTopBarDelegate <NSObject>

@optional
- (void)onMyTopBarTabSelected:(NSInteger)tabIndex;

@end

@interface MZLMyNormalTopBar : UIView

@property (nonatomic, weak) id<MZLMyTopBarDelegate> delegate;

+ (instancetype)tabBarInstance:(CGSize)parentViewSize;

- (void)onTabSelected:(NSInteger)selectedTabIndex;
- (void)updateUnreadCount;

@end

@interface MZLMyNormalTopBar (Protected)

- (NSArray *)tabNames;
- (NSArray *)tabIcons;
- (NSArray *)tabSelectedIcons;
- (NSArray *)tabIndexes;

@end
