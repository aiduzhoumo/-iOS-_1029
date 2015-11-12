//
//  MZLHomeViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15/3/23.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLHomeViewController.h"
#import "UIViewController+MZLiVersionSupport.h"
#import "MZLModelArticle.h"
#import "MZLModelLocationBase.h"
#import "MZLLocationDetailViewController.h"
#import "MZLTabBarViewController.h"
#import <IBMessageCenter.h>
#import "MZLPersonalizedFilterContentView.h"
#import "MZLModelShortArticle.h"

@interface MZLHomeViewController () <MZLPersonalizedFilterContentViewDelegate> {
}

@end

@implementation MZLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _mzl_homeOnViewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self _mzl_homeOnViewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self _mzl_homeOnViewWillDisappear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [IBMessageCenter removeMessageListenersForTarget:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - protected

- (void)_mzl_homeOnViewDidLoad {
    [self mzl_checkVersionIfNecessary];
    [self mzl_initLocation];
    [self _mzl_homeInternalInit];
    [self launchWithNotificationIfAny];
}

- (void)_mzl_homeOnViewDidAppear {
//    if (_isLocationInitialized && ![self hasFilters] && ! _hasRemoteNotification) {
//        [self showPersonalizedFilterView];
//    }
}

- (void)_mzl_homeOnViewWillDisappear {
    [self mzl_resetVersionDelegate];
    _hasRemoteNotification = NO;
}

#pragma mark - protected for override

- (void)_mzl_homeInternalInit {
}


#pragma mark - override

- (void)loadModelsWhenViewIsVisible {
//    if ([self isVisible] && ! [self hasFilters]) {
//        [self showPersonalizedFilterView];
//        return;
//    }
    [super loadModelsWhenViewIsVisible];
}

- (BOOL)_shouldRefreshOnViewWillAppear {
//    if (! _isLocationInitialized || ![self hasFilters]  || _hasRemoteNotification) {
//        return NO;
//    }
    if (! _isLocationInitialized || _hasRemoteNotification) {
        return NO;
    }
    return [super _shouldRefreshOnViewWillAppear];
}

#pragma mark - personalized filter view & delegate

//- (BOOL)shouldShowPersonalizedFilterView {
//    if (_isLocationInitialized && ![self hasFilters] && ! _hasRemoteNotification) {
//        return [self _shouldShowPersonalizedFilterView];
//    }
//    return NO;
//}
//
//- (BOOL)_shouldShowPersonalizedFilterView {
//    return YES;
//}

- (void)showPersonalizedFilterView {
    if (! _personalizedFilterContentView) {
        _personalizedFilterContentView = [MZLPersonalizedFilterContentView instanceWithFilterOptions:[self _filterOptions]];
        _personalizedFilterContentView.owner = self;
    }
    [_personalizedFilterContentView showWithDelegate:self];
}

- (void)onSkipFilter {
    MZLTabBarViewController *tabVc = (MZLTabBarViewController *)self.tabBarController;
    [tabVc toExploreTab];
}


#pragma mark - location related 

- (void)onLocationDone {
    _isLocationInitialized = YES;
    [self hideProgressIndicator:NO];
}

- (void)_mzl_initLocation_LocationIdentified {
    // 地址已经确定(eithor from GPS or cache)或地址获取已经失败(会在调用service的时候弹出城市列表)
    _requireRefreshOnViewWillAppear = YES;
    _isLocationInitialized = YES;
}

- (void)_mzl_onLocationUpdated {
    [self onLocationDone];
    [self loadModelsWhenViewIsVisible];
}

- (void)_mzl_onLocationError {
    [super _mzl_onLocationError];
    [self onLocationDone];
    if (! _models) {
        [self loadModelsWhenViewIsVisible];
    }
}

#pragma mark - notification related

- (void)launchWithNotificationIfAny {
    if (! [MZLSharedData hasApsInfo]) {
        return;
    }
    _hasRemoteNotification = YES;
    [self hideProgressIndicator:NO];
    if (!isEmptyString([[[MZLSharedData apsInfo] valueForKey:@"article"] valueForKey:@"id"])) {
        MZLModelArticle *article = [[MZLModelArticle alloc] init];
        article.identifier = [[[[MZLSharedData apsInfo] valueForKey:@"article"] valueForKey:@"id"] intValue];
        [self toArticleDetailWithArticle:article];
        [MZLSharedData setApnsInfo:nil];
    } else if (!isEmptyString([[[MZLSharedData apsInfo] valueForKey:@"destination"] valueForKey:@"id"])) {
        MZLModelLocationBase *location = [[MZLModelLocationBase alloc] init];
        location.identifier = [[[[MZLSharedData apsInfo] valueForKey:@"destination"] valueForKey:@"id"] intValue];
        [self toLocationDetailWithLocation:location];
        [MZLSharedData setApnsInfo:nil];
    } else if (!isEmptyString([[[MZLSharedData apsInfo] valueForKey:@"notice"] valueForKey:@"id"])) {
        MZLTabBarViewController *tabBarVC =  (MZLTabBarViewController *)self.tabBarController;
        [tabBarVC toMyTab];
    } else if (!isEmptyString([[[MZLSharedData apsInfo] valueForKey:@"short_article"] valueForKey:@"id"])) {
        MZLModelShortArticle *shortArticle = [[MZLModelShortArticle alloc] init];
        shortArticle.identifier = [[[[MZLSharedData apsInfo] valueForKey:@"short_article"] valueForKey:@"id"] intValue];
        [self toShortArticleDetailWithShortArticle:shortArticle];
        [MZLSharedData setApnsInfo:nil];
    }
}

@end
