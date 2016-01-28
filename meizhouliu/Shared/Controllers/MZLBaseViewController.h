//
//  MZLBaseViewController.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-20.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MZLAdditions.h"

@class MZLModelShortArticle, MZLModelUser, MZLModelLocationBase, MZLModelArticle;

@interface MZLBaseViewController : UIViewController <UIGestureRecognizerDelegate>  {
@protected
    BOOL _isDisplayed; /** 是否当前正在显示的controller */
}

- (NSString *)statsID;

// protected for child class
- (void)showNavBarAndTabBar:(BOOL)showFlag;
- (void)showTabBar:(BOOL)flag animatedFlag:(BOOL)animatedFlag;
- (void)showTabBar:(BOOL)flag;
- (BOOL)isNavRootViewController;
- (BOOL)isNavViewController;
- (void)toggleNavBarHidden:(BOOL)hiddenFlag;
- (void)toggleNavBarHidden:(BOOL)hiddenFlag animatedFlag:(BOOL)animatedFlag;

- (BOOL)isVisible;

- (BOOL)hasFilters;

// navigation
- (void)toAuthorDetailWithAuthor:(MZLModelUser *)user;
- (void)toArticleDetailWithArticle:(MZLModelArticle *)article;
- (void)toLocationDetailWithLocation:(MZLModelLocationBase *)location;
//- (void)toLocationDetail:(MZLModelLocationBase *)location selectedIndex:(NSInteger)selectedIndex;
- (void)toLocationDetailGoods:(MZLModelLocationBase *)location;
- (void)toLocationDetailLocations:(MZLModelLocationBase *)location;
- (void)toShortArticleDetailWithShortArticle:(MZLModelShortArticle *)shortArticle;
- (void)toShortArticleDetailWithShortArticle:(MZLModelShortArticle *)shortArticle commentFlag:(BOOL)flag;
- (void)toTuiJianDarenViewController;
@end