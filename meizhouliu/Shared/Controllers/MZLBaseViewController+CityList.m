//
//  MZLBaseViewController+CityList.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-17.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLBaseViewController+CityList.h"
#import "WeView.h"
#import "MZLCityListViewController.h"
#import "MZLTabBarViewController.h"
#import <IBAlertView.h>
#import <Masonry/Masonry.h>
#import "UIView+MZLAdditions.h"

#define LABEL_CITY_TAG 999
#define TEXT_NO_SELECTED_CITY @"请选择"

@implementation MZLBaseViewController (CityList)

- (UIView *)cityListDropdownView {
//    CGFloat hSpacing = 5.0;
//    CGFloat imageWidth = 8.0;
//    CGFloat totalWidth = 99.0;
//    WeView *view = [[WeView alloc] initWithFrame:CGRectMake(0, 0, totalWidth, self.navigationController.navigationBar.height)];
//    UILabel *lblTip = [[UILabel alloc] init];
//    lblTip.text = @"我在";
//    UILabel *lblCity = [[UILabel alloc] init];
//    for (UILabel *lbl in @[lblTip, lblCity]) {
//        lbl.font = MZL_BOLD_FONT(12.0);
//        lbl.textColor = MZL_COLOR_BLACK_555555();
//    }
//    [lblTip sizeToFit];
//    CGFloat lblTipWidth = lblTip.width;
//    lblCity.tag = LABEL_CITY_TAG;
//    [lblCity setMaxDesiredWidth:totalWidth - 2 * hSpacing - lblTipWidth - imageWidth];
//    NSString *city = [MZLSharedData selectedCity];
//    lblCity.text = isEmptyString(city) ? TEXT_NO_SELECTED_CITY : city;
//    UIImageView *image = [[UIImageView alloc] init];
//    image.image = [UIImage imageNamed:@"CityList_Arrow"];
//    [image setFixedDesiredSize:CGSizeMake(imageWidth, imageWidth)];
//    [[[view addSubviewsWithHorizontalLayout:@[lblTip, lblCity, image]]
//     setHSpacing:hSpacing]
//     setHAlign:H_ALIGN_LEFT];
//    [view addTapGestureRecognizer:self action:@selector(showCityList)];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.height, self.navigationController.navigationBar.height)];
//    view.backgroundColor = [UIColor grayColor];
    UIImageView *image = [view createSubViewImageView]; // [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    image.image = [UIImage imageNamed:@"CityList_Loc"];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(image.superview);
        make.centerY.mas_equalTo(image.superview);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [view addTapGestureRecognizer:self action:@selector(showCityList)];
    return view;
}

- (UIBarButtonItem *)cityListDropdownBarButtonItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[self cityListDropdownView]];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showCityList)];
    return item;
}

- (void)addCityListDropdownBarButtonItem {
    self.navigationItem.leftBarButtonItem = [self cityListDropdownBarButtonItem];
}

- (void)changeCityLabelText {
//    UIView *view = self.navigationItem.leftBarButtonItem.customView;
//    UILabel *lbl = (UILabel *)[view viewWithTag:LABEL_CITY_TAG];
//    NSString *newCity = [MZLSharedData selectedCity];
//    lbl.text = isEmptyString(newCity) ? TEXT_NO_SELECTED_CITY : newCity;
//    [lbl sizeToFit];
}

- (void)showCityList {
    UIStoryboard *modelStoryBoard = MZL_MODEL_STORYBOARD();
    UIViewController *controller = [modelStoryBoard instantiateViewControllerWithIdentifier:@"MZLCityListViewController"];
    if ([self.tabBarController isKindOfClass:[MZLTabBarViewController class]]) {
        MZLTabBarViewController *mzlTabBarController = (MZLTabBarViewController *)self.tabBarController;
        [mzlTabBarController showMzlTabBar:NO animatedFlag:NO];
    }
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)showCityListOnLocationNotDetermined {
    [IBAlertView showAlertWithTitle:MZL_MSG_ALERT_VIEW_TITLE message:MZL_LOCATION_SERVICES_ERROR dismissTitle:MZL_MSG_OK dismissBlock:^{
        [self showCityList];
    }];
}

/**
 *  Check whether selectedCity has been set.
 *
 *  @return BOOL - return YES if selectedCity is not set and will pop up city list; NO otherwise.
 */
- (BOOL)checkAndShowCityListOnLocationNotDetermined {
    NSString *selectedCity = [MZLSharedData selectedCity];
    if (isEmptyString(selectedCity)) {
        [self hideProgressIndicator:NO];
        [self showCityListOnLocationNotDetermined];
        return YES;
    }
    return NO;
}

@end
