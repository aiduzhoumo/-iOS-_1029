//
//  MZLHomeViewController.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15/3/23.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLTableViewControllerWithFilter.h"
#import "UIViewController+MZLLocationSupport.h"

@class MZLPersonalizedFilterContentView;

@interface MZLHomeViewController : MZLTableViewControllerWithFilter {
    @protected
    BOOL _isLocationInitialized;
    BOOL _hasRemoteNotification;
    
    MZLPersonalizedFilterContentView *_personalizedFilterContentView;
}

- (void)_mzl_homeInternalInit;

//- (BOOL)_shouldShowPersonalizedFilterView;

@end
