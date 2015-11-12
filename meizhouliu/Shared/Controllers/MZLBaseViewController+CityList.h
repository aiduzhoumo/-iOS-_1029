//
//  MZLBaseViewController+CityList.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-17.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLBaseViewController.h"

@interface MZLBaseViewController (CityList)

- (void)addCityListDropdownBarButtonItem;

- (void)changeCityLabelText;
- (void)showCityList;
- (void)showCityListOnLocationNotDetermined;
- (BOOL)checkAndShowCityListOnLocationNotDetermined;


@end
