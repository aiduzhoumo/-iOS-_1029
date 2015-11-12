//
//  UIViewController+MZLLocationSupport.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15/3/23.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MZLLocationSupport)

- (void)mzl_initLocation;
- (void)mzl_registerUpdateLocation;

// for override
- (void)_mzl_initLocation_LocationIdentified;
- (void)_mzl_onLocationError;
- (void)_mzl_onLocationUpdated;


@end
