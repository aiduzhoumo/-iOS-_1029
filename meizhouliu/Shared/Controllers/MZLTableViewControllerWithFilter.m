//
//  MZLTableViewControllerWithFilter.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-17.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLTableViewControllerWithFilter.h"
#import <IBMessageCenter.h>
#import "WeView.h"
#import "MZLFilterParam.h"
#import "MZLServices.h"
#import "MZLBaseViewController+CityList.h"
#import "MZLLocationDetailViewController.h"

@interface MZLTableViewControllerWithFilter () {
    WeView *_noRecordViewOnFilter;
    CO_BLOCK_VOID _filterHiddenBlock;
    NSDate *_filterViewDisappearTimeStamp;
}

@end

@implementation MZLTableViewControllerWithFilter

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [IBMessageCenter removeMessageListenersForTarget:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 隐藏filters
    if (_filterView) {
        [_filterView hide];
        _filterViewDisappearTimeStamp = [NSDate date];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // filterOptions在不同的Controller可能有不同的实现，所以service(涉及到filter的)应在viewWillAppear中调用
    if ([self _shouldShowFilterView]) {
        //目的地详情不显示距离选项
        if ([self parentViewController] && [[self parentViewController] isKindOfClass:[MZLLocationDetailViewController class]]) {
            _filterView = [MZLFilterContentView instanceWithFilterOptions:[self _filterOptions] showDistanceFlag:NO];
        } else {
            _filterView = [MZLFilterContentView instanceWithFilterOptions:[self _filterOptions] showDistanceFlag:YES];
        }
        
    }
    if ([self _shouldRefreshOnViewWillAppear]) {
        [self loadModels];
    }
    [self resetRefreshFlags];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_filterView) {
        [_filterView showWithDelegate:self];
    }
}

#pragma mark - protected

- (BOOL)hasFilters {
    return _filterView && [super hasFilters];
}

- (BOOL)isFilterOptionsShown {
    return [_filterView isFilterOptionsVisible];
}

- (void)filterHasModified {
}

//- (NSArray *)_textsOnFilterNoRecord {
//    return [NSArray array];
//}

- (NSArray *)noRecordTextsWithFilters {
    return [super noRecordTexts];
}

- (NSArray *)noRecordTextsWithoutFilters {
    return [super noRecordTexts];
}


- (void)resetRefreshFlags {
    _requireRefreshOnViewWillAppear = NO;
}

- (void)loadModelsWhenViewIsVisible {
    if ([self isVisible]) {
        [self loadModels];
    } else {
        // 从后台唤醒GPS定位发生变化时需要刷新
        _requireRefreshOnViewWillAppear = YES;
    }
}

- (BOOL)_shouldRefreshOnViewWillAppear {
    return !_models || _requireRefreshOnViewWillAppear || [_filterView isFilterModifiedSince:_filterViewDisappearTimeStamp];
}

- (BOOL)_shouldShowFilterView {
    return YES;
}

- (NSArray *)_filterOptions {
    return [MZLSharedData filterOptions];
}

#pragma mark - protected for load

- (void)_loadModelsWithoutFilters {
}

- (void)_loadModelsWithFilters:(MZLFilterParam *)filter {
}

- (void)_loadModels {
    _noRecordViewOnFilter.hidden = YES;
    // 如果filter已显示，则隐藏进度条
    if ([self isFilterOptionsShown]) {
        [self hideProgressIndicator:NO];
    }
    if ([self hasFilters]) {
        MZLFilterParam *filterParam = [MZLFilterParam filterParamsFromFilterTypes:[MZLSharedData selectedFilterOptions]];
        [self _loadModelsWithFilters:filterParam];
    } else {
        [self _loadModelsWithoutFilters];
    }
}

- (void)_onLoadSuccBlock:(NSArray *)modelsFromSvc {
    if ([self isFilterOptionsShown]) {
        [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_FILTER_QUERY_SUCCEED];
    }
//    [self showFilterNoRecordViewIfNecessary];
}

- (BOOL)_onLoadErrorBlock:(NSError *)error {
    if ([self isFilterOptionsShown]) {
        [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_FILTER_QUERY_FAILED];
    }
    return [super _onLoadErrorBlock:error];
}

#pragma mark - protected for load more

- (void)_loadMoreWithFilters:(MZLFilterParam *)filter {
}

- (void)_loadMoreWithoutFilters:(MZLPagingSvcParam *)pagingParam {
}

- (void)_loadMore {
    MZLPagingSvcParam *pagingParam = [self pagingParamFromModels];
    if ([self hasFilters]) {
        MZLFilterParam *filterParam = [MZLFilterParam filterParamsFromFilterTypes:[MZLSharedData selectedFilterOptions]];
        filterParam.pagingParam = pagingParam;
        [self _loadMoreWithFilters:filterParam];
        return;
    } else {
        [self _loadMoreWithoutFilters:pagingParam];
    }
}

#pragma mark - filter helper methods

- (MZLFilterParam *)filterParamWithDestination:(NSString *)destination {
    MZLFilterParam *filterParam = [MZLFilterParam filterParamsFromFilterTypes:[MZLSharedData selectedFilterOptions]];
    filterParam.destinationName = destination;
    filterParam.pagingParam = [self pagingParamFromModels];
    return filterParam;
}

- (MZLFilterParam *)filterParamWithSelectedCity {
    return [self filterParamWithDestination:[MZLSharedData selectedCity]];
}

#pragma mark - filter delegate

- (void)hideFilterView {
    if (_filterView) {
        [_filterView hide];
    }
    _filterViewDisappearTimeStamp = [NSDate date];
}
- (void)showFilterView {
    [_filterView showWithDelegate:self];
}

- (void)onFilterOptionsShown {
//    [self toggleStatusForFilters:YES];
}

- (void)onFilterOptionsWillHide {
    if (_loadOp && ! [_loadOp isFinished]) {
        [self showNetworkProgressIndicator];
    }
    [self showNavBarAndTabBar:YES];
}

- (void)onFilterOptionsHidden {
//    [self toggleStatusForFilters:NO];
    if (_filterHiddenBlock) {
        _filterHiddenBlock();
        _filterHiddenBlock = nil;
    }
}

- (void)onFilterOptionsModified {
    // cancel unfinished service calls and prepare for new calls
    if (_loadOp && ! [_loadOp isFinished]) {
        [_loadOp cancel];
    }
    [self loadModels];
}

- (void)addSwipeGestureRecognizerToShowFilterOptions:(UISwipeGestureRecognizer *)swipeGesture {
    [self.view addGestureRecognizer:swipeGesture];
}

- (void)removeSwipeGestureRecognizer:(UISwipeGestureRecognizer *)swipeGesture {
    [self.view removeGestureRecognizer:swipeGesture];
}

#pragma mark - override

- (NSArray *)noRecordTexts {
    if ([self hasFilters]) {
        return [self noRecordTextsWithFilters];
    } else {
        return [self noRecordTextsWithoutFilters];
    }
}

- (void)mzl_pushViewController:(UIViewController *)vc {
    if (_filterView && [_filterView isFilterOptionsVisible]) {
        __weak UIViewController *weakSelf = self;
        _filterHiddenBlock = ^ {
            [weakSelf hideProgressIndicator:NO];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController pushViewController:vc animated:YES];
            });
        };
        [_filterView hideFilterOptions];
    }else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)mzl_onWillBecomeTabVisibleController {
    [self loadModelsWhenViewIsVisible];
}

@end
