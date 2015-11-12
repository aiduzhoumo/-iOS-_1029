//
//  MZLSystemArticleListViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-6-26.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLSystemArticleListViewController.h"
#import "MZLServices.h"
#import "MZLiVersionDelegate.h"
#import <IBMessageCenter.h>
#import "MZLCityListViewController.h"
#import "MobClick.h"
#import "WeView.h"
#import "MZLSelectedArticleListResponse.h"
#import "MZLTabBarViewController.h"
#import "UIView+MBProgressHUDAdditions.h"
#import "MZLModelArticle.h"
#import "MZLModelLocation.h"
#import "MZLBaseViewController+CityList.h"
#import "MZLFilterParam.h"
#import "UIScrollView+MZLAddition.h"

@interface MZLSystemArticleListViewController () {
//    BOOL _isLocationInitialized;
//    BOOL _skipRefreshOnLocationNotChanged;
//    BOOL _requireRefreshOnViewWillAppear;
    BOOL _isDisplaySystemArticles; /* 是否当前选中目的地没有玩法，显示的是系统推荐文章/玩法 */
    NSString *_location;
}

@end

@implementation MZLSystemArticleListViewController

#pragma mark - lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _requireRefreshOnViewWillAppear = YES;
    // Do any additional setup after loading the view.
//    [self launchWithNotificationIfAny];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self adjustTableViewBottomInset:MZL_TAB_BAR_HEIGHT scrollIndicatorBottomInset:MZL_TAB_BAR_HEIGHT];
}

#pragma mark - override

- (void)initControls {
    [super initControls];
//    [self addCityListDropdownBarButtonItem];
}

///** 没有选中目的地不能调用filter service，所以需要额外判断 */
//- (BOOL)hasFilters {
//    BOOL resultFromSuper = [super hasFilters];
//    BOOL hasCity = ! isEmptyString([MZLSharedData selectedCity]);
//    return resultFromSuper && hasCity;
//}

//- (void)filterHasModified {
//    _requireRefreshOnViewWillAppear = YES;
//}

//- (BOOL)_shouldRefreshOnViewWillAppear {
//    // 须先等location刷新再加载数据
//    return _isLocationInitialized && [super _shouldRefreshOnViewWillAppear];
//}

- (BOOL)_shouldShowFilterView {
    return NO;
}

- (void)loadModels {
    _location = [MZLSharedData selectedCity];
    [super loadModels];
}

#pragma mark - init methods

- (UIView *)headerViewForNoArticlesForSelectedCity {
    CGFloat topMargin = 5.0;
    CGFloat bottomMargin = MZL_ARTICLE_LIST_VC_TV_MARGIN;
    CGFloat height = 30.0 + topMargin + bottomMargin;
    WeView *view = [[WeView alloc] initWithFrame:CGRectMake(0, 0, _tv.width, height)];
    UILabel *lbl = [[UILabel alloc] init];
    lbl.font = MZL_FONT(12.0);
    lbl.numberOfLines = 2;
    lbl.textColor = MZL_COLOR_BLACK_999999();
    if (_location) {
        lbl.text = MZL_ARTICLE_LIST_DISPLAY_SYSTEM_ARTICLES;
    } else {
        lbl.text = MZL_ARTICLE_LIST_DISPLAY_SYSTEM_ARTICLES_NO_LOCATION;
    }
    [[[[view addSubviewsWithVerticalLayout:@[lbl]]
       setTopMargin:topMargin]
      setBottomMargin:bottomMargin]
     setHMargin:MZL_ARTICLE_LIST_VC_TV_MARGIN];
    return view;
}

#pragma mark - protected for load

- (void)_loadModelsWithoutFilters {
    self.title = @"精选玩法";
    if (_location) {
        [self invokeService:@selector(articleListServiceWithLocationName:succBlock:errorBlock:) params:@[_location]];
    } else { // 默认精选列表
        MZLArticleListSvcParam * param = [MZLArticleListSvcParam instanceWithDefaultPagingParam];
        [self invokeService:@selector(systemArticleListService:succBlock:errorBlock:) params:@[param]];
    }
}

- (NSMutableArray *)mapModelsOnLoad:(NSArray *)modelsFromSvc {
    MZLSelectedArticleListResponse *response = modelsFromSvc[0];
    _isDisplaySystemArticles = response.isSystemArticles;
    if (_isDisplaySystemArticles) {
        _tv.tableHeaderView = [self headerViewForNoArticlesForSelectedCity];
    } else {
        _tv.tableHeaderView = nil;
    }
    return [NSMutableArray arrayWithArray:response.articles];
}

#pragma mark - protected for load more

- (NSArray *)mapModelsOnLoadMore:(NSArray *)modelsFromSvc {
    MZLSelectedArticleListResponse *response = modelsFromSvc[0];
    return response.articles;
}

- (void)_loadMoreArticlesWithoutFilters:(MZLArticleListSvcParam *)param {
    if (_isDisplaySystemArticles) {
        [self invokeLoadMoreService:@selector(systemArticleListService:succBlock:errorBlock:) params:@[param]];
    } else {
        param.locationName = _location;
        [self invokeLoadMoreService:@selector(articleListService:succBlock:errorBlock:) params:@[param]];
    }
}

#pragma mark - statsID

- (NSString *)statsID {
    return @"文章精选";
}

@end
