//
//  MZLLocationDetailViewController.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-15.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLBaseViewController.h"

#define MZL_SEGUE_TOMAP @"toMap"
//#define MZL_LOCATION_DETAIL_INFO_SECTION 0
#define MZL_LOCATION_DETAIL_ARTICLES_SECTION 0
#define MZL_LOCATION_DETAIL_LOCATIONS_SECTION 1
#define MZL_LOCATION_DETAIL_GOODS_SECTION 2

@class MZLModelLocationBase;

@interface MZLLocationDetailViewController : MZLBaseViewController<UITabBarDelegate>

//@property (weak, nonatomic) IBOutlet UIButton *btnAddAsInterested;
@property (weak, nonatomic) IBOutlet UIView *vwContent;
@property (weak, nonatomic) IBOutlet UITabBar *vwTabBar;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consTabbarBottom;

@property (nonatomic, strong) MZLModelLocationBase *locationParam;
@property (nonatomic, assign) NSInteger selectedIndex;

//- (IBAction)addCurLocAsInterested:(id)sender;
- (void)tabToSelectedIndex:(NSInteger)index;

- (void)showLocationDetailTabBar:(BOOL)flag;
- (void)showLocationDetailTabBar:(BOOL)flag completion:(void (^)(void))completion;
- (void)toggleFavor;

- (void)toLocationInfo;
- (void)toMap;

@end
