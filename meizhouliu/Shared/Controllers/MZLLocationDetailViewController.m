//
//  MZLLocationDetailViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-15.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLLocationDetailViewController.h"
#import "MZLArticleItemTableViewCell.h"
#import "MZLModelLocationDetail.h"
#import "MZLLocationMapViewController.h"
#import "MZLLocDetailTableFooterView.h"
#import "MZLUserLocPrefResponse.h"
#import "MZLArticleDetailViewController.h"
#import "MobClick.h"
#import <IBMessageCenter.h>

#import "MZLLoginViewController.h"
#import "MZLLocationArticleListViewController.h"
#import "MZLChildLocationsViewController.h"

#import "MZLServices.h"
#import "UIBarButtonItem+COAdditions.h"
#import "UIView+MZLAdditions.h"
#import "MZLLocationGoodsViewController.h"
#import "MZLGoodsDetailViewController.h"
#import "MZLPagingSvcParam.h"
#import "MZLLocationInfoViewController.h"

#define KEY_CHILDLOCATION @"KEY_CHILDLOCATION"

#define SEGUE_TOCHILDLOCATION @"toChildLocation"
#define SEGUE_TOCHILDLOCATIONS @"toChildLocations"
#define SEGUE_TOARTICLELIST @"toArticleList"

@interface MZLLocationDetailViewController () {
    
    MZLModelLocationDetail *_locationDetail;
    MZLModelUserLocationPref *_userLocPref;
//    MZLLocDetailHeaderAddressView *_titleView;
    
    UIImageView *_navBarHairlineImageView;
    UIBarButtonItem *_interestBtn;
    UIBarButtonItem * _mapBtn;
    
    BOOL _shouldRefreshFavorData;
    
    UIViewController *_selectedChildVC;
    
    MZLLocationArticleListViewController *_vcLocArticleList;
    MZLChildLocationsViewController *_vcChildLocations;
    MZLLocationGoodsViewController *_vcGoods;
    
    NSArray *_allTabItems;
}



@end

@implementation MZLLocationDetailViewController

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
    
    _vcLocArticleList = [MZL_MAIN_STORYBOARD() instantiateViewControllerWithIdentifier:@"sbLocArticleList"];
    _vcChildLocations = [MZL_MAIN_STORYBOARD() instantiateViewControllerWithIdentifier:@"sbChildLocations"];
    _vcGoods = [MZL_MAIN_STORYBOARD() instantiateViewControllerWithIdentifier:@"sbLocGoodsList"];
    
    [self initTabBar];
    [self initNavbarItems];
    self.lblTitle.textColor = MZL_NAVBAR_TITLE_COLOR();
    self.lblTitle.text = nil;
    self.view.backgroundColor = MZL_BG_COLOR();
    _navBarHairlineImageView = [UIView mzl_hairlineImageInView:self.navigationController.navigationBar];
//    [self loadGoodsData];
    [self refreshData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_selectedChildVC == _vcChildLocations) {
        _navBarHairlineImageView.hidden = YES;
    }
    if (_shouldRefreshFavorData) {
        [self refreshFavorData];
        _shouldRefreshFavorData = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.childViewControllers.count == 0 && _locationDetail) {
        [self tabToSelectedIndex];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _navBarHairlineImageView.hidden = NO;
    [self.navigationController.navigationBar setHidden:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [IBMessageCenter removeMessageListenersForTarget:self];
}

#pragma mark - service related

- (void)loadGoodsData {
//    MZLPagingSvcParam *param = [MZLPagingSvcParam pagingSvcParamWithPageIndex:1 fetchCount:5];
//    [MZLServices locationGoodsService:self.locationParam pagingParam:param succBlock:^(NSArray *models) {
//        if (models.count > 0) {
//            [self showGoodsTab];
//        }
//    } errorBlock:^(NSError *error) {
//        // ignore
//    }];
}

- (void)refreshData {
    [self showNetworkProgressIndicator];
    [self refreshFavorData];
    [MZLServices locationDetailService:self.locationParam.identifier succBlock:^(NSArray *models) {
    
        [self onSvcSuccess:models];
    } errorBlock:^(NSError *error) {
        [self onNetworkError:error];
    }];
}

- (void)refreshFavorData {
    [MZLServices isLocationFavoredService:self.locationParam succBlock:^(NSArray *models) {
        if ([models[0] isKindOfClass:[MZLUserLocPrefResponse class]]) {
            _userLocPref = ((MZLUserLocPrefResponse *)models[0]).userLocationPref;
            [self changeFavoredImageWithUserLocPref:_userLocPref];
        }
    } errorBlock:^(NSError *error) {}];
}

- (void)onSvcSuccess:(NSArray *)mappedModels {
    _locationDetail = nil;
    if ([mappedModels[0] isKindOfClass:[MZLModelLocationDetail class]]) {
        _locationDetail = mappedModels[0];
        // 切换要在viewDidAppear后执行
        if (_isDisplayed) {
            [self tabToSelectedIndex];
        }
    }
//    [self hideProgressIndicator];
}

- (void)onLoginStatusModified {
    [self refreshFavorDataWhenViewIsVisible];
}

- (void)refreshFavorDataWhenViewIsVisible {
    if ([self isVisible]) {
        [self refreshFavorData];
    } else {
        _shouldRefreshFavorData = YES;
    }
}

#pragma mark - internal init

- (UIBarButtonItem *)fixedSpaceItem {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 3.0, 21.0)];
    view.backgroundColor = [UIColor clearColor];
    return [[UIBarButtonItem alloc]initWithCustomView:view];
}

- (void)initNavbarItems {
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_LOGINED target:self action:@selector(onLoginStatusModified)];
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_LOGOUT target:self action:@selector(onLoginStatusModified)];
    
//    _mapBtn = [UIBarButtonItem itemWithSize:CGSizeMake(24.0, 24.0) imageName:@"Map_Grey" target:self action:@selector(toMap)];
    
    _interestBtn = [UIBarButtonItem itemWithSize:CGSizeMake(24.0, 24.0) image:[self imageForFavoredLocation:_userLocPref] target:self action:@selector(toggleFavor)];
    self.navigationItem.rightBarButtonItem = _interestBtn;
//    self.navigationItem.rightBarButtonItems =  @[_mapBtn, [self fixedSpaceItem], _interestBtn];
}

//- (UIView *)titleView {
//    MZLLocDetailHeaderAddressView *view = [MZLLocDetailHeaderAddressView instance:_locationDetail userLocPref:_userLocPref];
//    _titleView = view;
//    [_titleView.vwInterestClickable addTapGestureRecognizer:self action:@selector(toggleFavor)];
//    return view;
//}

/*
 Search for http://stackoverflow.com/questions/11512783/unselected-uitabbar-color/18433996#18433996
 If you set the icon in the story board only, you can control the color of the selected tab only (tintColor).
 All other icons and corresponding text will be drawn in gray.
 */
- (void)initTabBar {
    // set color of selected icons and text to MZL_YELLOW
    self.vwTabBar.tintColor = MZL_COLOR_YELLOW_FDD414();
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: colorWithHexString(@"#4c3b14"), NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:colorWithHexString(@"#929292"), NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    _allTabItems = self.vwTabBar.items;
    
    // set selected and unselected icons
    UITabBarItem *itemLocArticle = [_allTabItems objectAtIndex:0];
    UITabBarItem *itemLocSurrounds = [_allTabItems objectAtIndex:1];
    UITabBarItem *itemGoods = [_allTabItems objectAtIndex:2];
    
    // this way, the icon gets rendered as it is (thus, it needs to be MZL_GREEN in MZL)
    itemLocArticle.image = [[UIImage imageNamed:@"tab_article"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    itemLocSurrounds.image = [[UIImage imageNamed:@"tab_surrounds"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    itemGoods.image = [[UIImage imageNamed:@"tab_goods"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // this icon is used for selected tab and it will get tinted as defined in self.tabBar.tintColor
    itemLocArticle.selectedImage = [[UIImage imageNamed:@"tab_article_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    itemLocSurrounds.selectedImage = [[UIImage imageNamed:@"tab_surrounds_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    itemGoods.selectedImage = [[UIImage imageNamed:@"tab_goods_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.vwTabBar.selectedItem = [self.vwTabBar items][self.selectedIndex];
    
    // 暂时隐藏商品tab,如果确实有商品再显示
//    self.vwTabBar.items = [self.vwTabBar.items subarrayWithRange:NSMakeRange(0, 3)];
    
    UIView *topSep = [self.vwTabBar mzl_createTabSeparator];
    [topSep co_topParent];
}

- (void)showGoodsTab {
    self.vwTabBar.items = _allTabItems;
    self.vwTabBar.selectedItem = [self.vwTabBar items][self.selectedIndex];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:SEGUE_TOCHILDLOCATION]) {
        MZLLocationDetailViewController *vcChildLocation = segue.destinationViewController;
        vcChildLocation.locationParam = sender;
    } else if ([segue.identifier isEqualToString:MZL_SEGUE_TOMAP]) {
        MZLLocationMapViewController *vcMap = segue.destinationViewController;
        vcMap.location = _locationDetail;
    }
//    else if ([segue.identifier isEqualToString:SEGUE_TOARTICLELIST]) {
//        MZLLocationArticleListViewController *vcArticleList = segue.destinationViewController;
//        vcArticleList.locationParam = _locationDetail;
//    } else if ([segue.identifier isEqualToString:SEGUE_TOCHILDLOCATIONS]) {
//        MZLChildLocationsViewController *vcChildLocations = segue.destinationViewController;
//        vcChildLocations.locationParam = _locationDetail;
//    }
    else if ([segue.identifier isEqualToString:MZL_SEGUE_TOARTICLEDETAIL]) {
        MZLArticleDetailViewController *vcArticleDetail = segue.destinationViewController;
        vcArticleDetail.targetLocation = _locationDetail;
    } else if ([segue.identifier isEqualToString:MZL_SEGUE_TOGOODSDETAIL]) {
        MZLGoodsDetailViewController *vcGoodsDetail = segue.destinationViewController;
        vcGoodsDetail.goodsUrl = (NSString *)sender;
    }
}

- (void)toMap {
    [self performSegueWithIdentifier:MZL_SEGUE_TOMAP sender:nil];
}

- (void)toArticleList:(id)sender {
    [self performSegueWithIdentifier:SEGUE_TOARTICLELIST sender:nil];
    [MobClick event:@"clickLocationDetailPlayTotal"];
}

- (void)toChildLocations:(id)sender {
    [self performSegueWithIdentifier:SEGUE_TOCHILDLOCATIONS sender:nil];
    [MobClick event:@"clickLocationDetailLocationTotal"];
}

- (void)toChildLocation:(UITapGestureRecognizer *)recognizer {
    MZLModelLocation *childLocation = [recognizer.view getProperty:KEY_CHILDLOCATION];
    [self performSegueWithIdentifier:SEGUE_TOCHILDLOCATION sender:childLocation];
    [MobClick event:@"clickLocationDetailLocationSingle"];
}

- (void)toLocationInfo {
    MZLLocationInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MZLLocationInfoViewController class])];
    vc.locationDetail = _locationDetail;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

#pragma mark - user favored location

- (void)onFavorServiceSucceed:(MZLModelUserLocationPref *)userLocPref {
    [self onFavorServiceFinished];
    _userLocPref = userLocPref;
    [self changeFavoredImageWithUserLocPref:userLocPref];
    [self showNotiTipOnFavoredLocStatusChanged:userLocPref];
}

- (void)changeFavoredImageWithUserLocPref:(MZLModelUserLocationPref *)userLocPref {
    UIButton *innerBtn = (UIButton *)_interestBtn.customView;
    [innerBtn setImage:[self imageForFavoredLocation:_userLocPref] forState:UIControlStateNormal];
    [_vcLocArticleList toggleFavoredImage:userLocPref];
}

- (void)onFavorServiceFailure:(NSError *)error {
    [self onPostError:error];
}

- (void)onFavorServiceFinished {
    [self hideProgressIndicator];
}

- (void)toggleFavor {
    if (shouldPopupLogin()) {
        [self popupLoginFrom:MZLLoginPopupFromInterestedLocation executionBlockWhenDismissed:nil];
        return;
    }
    [self _toggleFavor];
}

- (void)_toggleFavor {
    [self showWorkInProgressIndicator];
    if (_userLocPref) {
        [MZLServices removeFavoredLocation:_userLocPref succBlock:^(NSArray *models) {
            [self onFavorServiceSucceed:nil];
        } errorBlock:^(NSError *error) {
            [self onFavorServiceFailure:error];
        }];
    } else {
        [MZLServices addLocationAsFavored:self.locationParam.identifier succBlock:^(NSArray *models) {
            MZLUserLocPrefResponse *response = models[0];
            [self onFavorServiceSucceed:response.userLocationPref];
        } errorBlock:^(NSError *error) {
            [self onFavorServiceFailure:error];
        }];
    }
    [MobClick event:@"clickLocationDetailWant"];
}

#pragma mark - stats

- (NSString *)statsID {
    return @"目的地详情";
}

#pragma mark - Tab bar delegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 0) {
        _vcLocArticleList.locationParam = _locationDetail;
        _vcLocArticleList.ownerVc = self;
        _vcLocArticleList.locUserPref = _userLocPref;
        [self tabToViewController:_vcLocArticleList];
    } else if (item.tag == 1) {
        _vcChildLocations.locationParam = _locationDetail;
        [self tabToViewController:_vcChildLocations];
        
    } else if (item.tag == 2) {
        _vcGoods.locationParam = _locationDetail;
        [self tabToViewController:_vcGoods];
    }
}

#pragma mark - transition among child VC

- (void)onChildVcDidChanged {
    self.lblTitle.text = self.locationParam.name;
    _navBarHairlineImageView.hidden = NO;
    if (_selectedChildVC == _vcChildLocations) {
        _navBarHairlineImageView.hidden = YES;
    }
}

- (void)tabToViewController:(UIViewController *)toController {
    if (_selectedChildVC != toController) {
        _selectedChildVC = toController;
        [self mzl_flipToChildViewController:toController inView:self.vwContent];
        [self onChildVcDidChanged];
//        if (self.selectedIndex > 0) {
//            [toController viewWillAppear:YES];
//            [toController viewDidAppear:YES];
//            self.selectedIndex = 0;
//        }
    }
}

- (void)tabToSelectedIndex:(NSInteger)index {
    self.selectedIndex = index;
    [self tabToSelectedIndex];
}

- (void)tabToSelectedIndex {
    self.vwTabBar.selectedItem = [self.vwTabBar items][self.selectedIndex];
    [self tabBar:self.vwTabBar didSelectItem:self.vwTabBar.items[self.selectedIndex]];
//    self.selectedIndex = 0;
}

#pragma mark - override parent

- (void)mzl_pushViewController:(UIViewController *)vc {
    [self.childViewControllers[0] mzl_pushViewController:vc];
}

#pragma mark - show or hide tab bar

- (void)showLocationDetailTabBar:(BOOL)flag completion:(void (^)(void))completion {
    if (flag) {
        self.consTabbarBottom.constant = 0;
    } else {
        self.consTabbarBottom.constant = -MZL_TAB_BAR_HEIGHT;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.vwTabBar layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)showLocationDetailTabBar:(BOOL)flag {
    [self showLocationDetailTabBar:flag completion:nil];
}

@end
