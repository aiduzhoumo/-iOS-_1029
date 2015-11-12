//
//  MZLExploreViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-11-24.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLExploreViewController.h"
#import <Masonry/Masonry.h>
#import "MZLBaseViewController+CityList.h"
#import "UIViewController+MZLAdditions.h"
#import <IBMessageCenter.h>
#import "MZLTableViewController.h"
#import "UIView+MZLAdditions.h"

#define TAG_RECOMMEND_ARTICLE_VC 99
#define TAG_HOT_GOODS 100
#define TITLE_FONT_SIZE 14.0

@interface MZLExploreViewController () {
    UIViewController *_childRecommendArticleListVC;
    UIViewController *_childHotGoodsVC;
    __weak UIViewController *_selectedChildVC;
    __weak UIView *_vwTabHeader;
    __weak UIView *_vwCenter;
    __weak UILabel *_leftTitleLbl;
    __weak UILabel *_rightTitleLbl;
    __weak UILabel *_selectedTitleLbl;
    __weak UIView *_titleIndicator;
    __weak MASViewConstraint *_indicatorCentenXCons;
}

@end

@implementation MZLExploreViewController

#pragma mark - view life cycle

- (void)viewDidLoad {
    self.title = @"精选";
    
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_LOCATION_UPDATED target:self action:@selector(onLocationUpdated)];
    
    _childRecommendArticleListVC = [MZL_MAIN_STORYBOARD() instantiateViewControllerWithIdentifier:@"systemArticleVC"];
    _childHotGoodsVC = [MZL_MAIN_STORYBOARD() instantiateViewControllerWithIdentifier:@"MZLHotGoodsVC"];
    
    [self initUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (! _selectedChildVC) {
        [self switchToChildVCWithTag:TAG_RECOMMEND_ARTICLE_VC];
    }
}

#pragma mark - UI

- (void)initUI {
    [self initHeaderTabBar];
    [self initCenterView];
}

- (void)initCenterView {
    UIView *centerView = [self.vwContent createSubView];
    _vwCenter = centerView;
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(centerView.superview);
        make.top.mas_equalTo(_vwTabHeader.mas_bottom);
    }];
}

- (void)initHeaderTabBar {
    UIView *headerTabBar = [self.vwContent createSubView];
    _vwTabHeader = headerTabBar;
    [headerTabBar co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, 0) width:COInvalidCons height:40.0];
    
    CGFloat spacing = 80.0;
    UIView *headerTabCenter = [[headerTabBar createSubView] co_insetsParent:UIEdgeInsetsMake(0, COInvalidCons, 0, COInvalidCons)];
    [headerTabCenter co_centerXParent];
    UILabel *leftLbl = [headerTabCenter createSubViewLabelWithFont:MZL_BOLD_FONT(TITLE_FONT_SIZE) textColor:@"434343".co_toHexColor];
    leftLbl.text = @"精选玩法";
    [leftLbl co_insetsParent:UIEdgeInsetsMake(0, COInvalidCons, 0, COInvalidCons)];
    [leftLbl co_leftParentWithOffset:spacing / 2.0];
    UILabel *rightLbl = [headerTabCenter createSubViewLabelWithFontSize:TITLE_FONT_SIZE textColor:@"999999".co_toHexColor];
    rightLbl.text = @"爆款商品";
    [rightLbl co_insetsParent:UIEdgeInsetsMake(0, COInvalidCons, 0, COInvalidCons)];
    [rightLbl co_rightParentWithOffset:spacing / 2.0];
    [rightLbl co_leftFromRightOfPreSiblingWithOffset:spacing];
    UIView *indicator = [[[headerTabCenter createSubView] co_bottomParent] co_width:100.0 height:4.0];
    indicator.backgroundColor = @"FFD414".co_toHexColor;
    NSArray *constraints = [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(leftLbl.mas_centerX);
    }];
    _indicatorCentenXCons = constraints[0];
    leftLbl.tag = TAG_RECOMMEND_ARTICLE_VC;
    rightLbl.tag = TAG_HOT_GOODS;
    [leftLbl addTapGestureRecognizer:self action:@selector(onTitleLabelClicked:)];
    [rightLbl addTapGestureRecognizer:self action:@selector(onTitleLabelClicked:)];
    _titleIndicator = indicator;
    _leftTitleLbl = leftLbl;
    _rightTitleLbl = rightLbl;
    _selectedTitleLbl = leftLbl;
}

- (void)onTitleLabelClicked:(UITapGestureRecognizer *)tap {
    UILabel *lbl = (UILabel *)(tap.view);
    [self switchToChildVCWithTag:lbl.tag];
}

- (void)indicatorAnimation {
    [_indicatorCentenXCons uninstall];
    NSArray *constraints = [_titleIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_selectedTitleLbl.mas_centerX);
    }];
    _indicatorCentenXCons = constraints[0];
    [UIView animateWithDuration:0.3 animations:^{
        [_vwTabHeader layoutIfNeeded];
    }];
}

- (void)toggleTitleLabel:(NSInteger)tag {
    UILabel *toLabel = (tag == TAG_RECOMMEND_ARTICLE_VC) ? _leftTitleLbl : _rightTitleLbl;
    if (_selectedTitleLbl == toLabel) {
        return;
    }
    _selectedTitleLbl.font = MZL_FONT(TITLE_FONT_SIZE);
    _selectedTitleLbl.textColor = @"999999".co_toHexColor;
    toLabel.font = MZL_BOLD_FONT(TITLE_FONT_SIZE);
    toLabel.textColor = @"434343".co_toHexColor;
    _selectedTitleLbl = toLabel;
    [self performSelector:@selector(indicatorAnimation) withObject:nil afterDelay:0.3];
}

#pragma mark - childVC switch

- (void)switchToChildVCWithTag:(NSInteger)tag {
    [self toggleTitleLabel:tag];
    UIViewController *toVC = (tag == TAG_RECOMMEND_ARTICLE_VC) ? _childRecommendArticleListVC : _childHotGoodsVC;
    if (toVC == _selectedChildVC) {
        return;
    }
    if (toVC == _childRecommendArticleListVC) {
        [self addCityListDropdownBarButtonItem];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
    _selectedChildVC = toVC;
    [self mzl_flipToChildViewController:_selectedChildVC inView:_vwCenter];
    [_selectedChildVC mzl_onWillBecomeTabVisibleController];
}

#pragma mark - override

- (void)mzl_onWillBecomeTabVisibleController {
    [_selectedChildVC mzl_onWillBecomeTabVisibleController];
}

#pragma mark - location related

- (void)onLocationUpdated {
    if (_selectedChildVC == _childRecommendArticleListVC) {
        [self changeCityLabelText];
        MZLTableViewController *tabVC = (MZLTableViewController *)_selectedChildVC;
        [tabVC loadModelsWhenViewIsVisible];
    }
}

@end
