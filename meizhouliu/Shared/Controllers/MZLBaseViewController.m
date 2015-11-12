//
//  MZLBaseViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-20.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLBaseViewController.h"
#import "UIViewController+MZLAdditions.h"
#import "MZLAuthorDetailViewController.h"
#import "MZLLocationDetailViewController.h"
#import "MZLArticleDetailViewController.h"
#import "MobClick.h"
#import "MZLTabBarViewController.h"
#import "MZLNoticeDetailViewController.h"
#import "MZLLocationDetailViewController.h"
#import "MZLShortArticleDetailVC.h"
#import "MZLModelShortArticle.h"
#import "MZLModelAuthor.h"

// in hours
#define REFRESH_INTERVAL_IN_HOURS 12

@interface MZLBaseViewController () {
    BOOL _backWithSwipeGesture;
}

@end

@implementation MZLBaseViewController

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
    // add back button
    if ([self isNavViewController] && [self requiresBackButton]) {
        self.navigationItem.leftBarButtonItem = [self backBarButtonItemWithImageNamed:@"BackArrow" action:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self isNavViewController]) {
        [self showTabBar:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _isDisplayed = YES;
    if ([self statsID]) {
        [MobClick beginLogPageView:[self statsID]];
    }
    if ([self isNavRootViewController]) {
        [self showTabBar:YES];
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    } else if ([self isNavViewController]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 如果在navigationController中，恢复navigationController显示
    [self toggleNavBarHidden:NO animatedFlag:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _isDisplayed = NO;
    if ([self statsID]) {
        [MobClick endLogPageView:[self statsID]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - protected

- (BOOL)requiresBackButton {
    return YES;
}

#pragma mark - misc

- (BOOL)hasFilters {
    NSArray *filters = [MZLSharedData selectedFilterOptions];
    return filters.count > 0;
}

- (BOOL)isNavViewController {
    if (self.navigationController && [self.navigationController.tabBarController isMemberOfClass:[MZLTabBarViewController class]]) {
        UIViewController *rootVC = self.navigationController.viewControllers[0];
        return (rootVC != self && rootVC != self.parentViewController);
    }
    return NO;
}

- (BOOL)isNavRootViewController {
    if (self.navigationController && [self.navigationController.tabBarController isMemberOfClass:[MZLTabBarViewController class]]) {
        UIViewController *rootVC = self.navigationController.viewControllers[0];
        return (rootVC == self || rootVC == self.parentViewController);
    }
    return NO;
}

- (BOOL)isVisible {
    return [self co_isVisible];
}

- (void)showNavBarAndTabBar:(BOOL)showFlag {
    [self toggleNavBarHidden:! showFlag];
    if ([self isNavRootViewController]) {
        [self showTabBar:showFlag];
    }
}

#pragma mark - Tab bar logic

- (void)showTabBar:(BOOL)flag {
    [self showTabBar:flag animatedFlag:YES];
}

- (void)showTabBar:(BOOL)flag animatedFlag:(BOOL)animatedFlag {
    MZLTabBarViewController *mzlTabBarController = (MZLTabBarViewController *)self.tabBarController;
    if (! mzlTabBarController) {
        return;
    }
    [mzlTabBarController showMzlTabBar:flag animatedFlag:animatedFlag];
}

#pragma mark - Navgation bar logic

- (void)toggleNavBarHidden:(BOOL)hiddenFlag {
    [self toggleNavBarHidden:hiddenFlag animatedFlag:YES];
}

- (void)toggleNavBarHidden:(BOOL)hiddenFlag animatedFlag:(BOOL)animatedFlag {
    if (! self.navigationController) {
        return;
    }
    BOOL isNavHidden = self.navigationController.isNavigationBarHidden;
    if (hiddenFlag == isNavHidden) {
        return;
    }
//    [UIView animateWithDuration:0.2 animations:^{
//        MZLTabBarViewController *tabBarController = (MZLTabBarViewController *)self.tabBarController;
//        [tabBarController showMzlTabBar:! hiddenFlag];
//    }];
    [self.navigationController setNavigationBarHidden:hiddenFlag animated:animatedFlag];
    //    if (animatedFlag) {
    //        [UIView animateWithDuration:0.2 animations:^{
    //            [self.navigationController setNavigationBarHidden:hiddenFlag animated:NO];
    //        }];
    //    } else {
    //        [self.navigationController setNavigationBarHidden:hiddenFlag animated:NO];
    //    }
}


#pragma mark - Gesture recognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    // most used segue
    if ([segue.identifier isEqualToString:MZL_SEGUE_TOARTICLEDETAIL]) {
        MZLArticleDetailViewController *vcArticleDetail = (MZLArticleDetailViewController *)segue.destinationViewController;
        vcArticleDetail.articleParam = sender;
    } else if ([segue.identifier isEqualToString:MZL_SEGUE_TOAUTHORDETAIL]) {
        MZLAuthorDetailViewController *vcAuthor = (MZLAuthorDetailViewController *)segue.destinationViewController;
        vcAuthor.authorParam = sender;
    } else if ([segue.identifier isEqualToString:MZL_SEGUE_TOLOCATIONDETAIL]) {
        MZLLocationDetailViewController *vcLocationDetail = (MZLLocationDetailViewController *)segue.destinationViewController;
        vcLocationDetail.locationParam = sender;
    }else if ([segue.identifier isEqualToString:MZL_SEGUE_NOTICEDETAIL]) {
        MZLNoticeDetailViewController *vcNoticeDetail = (MZLNoticeDetailViewController *)segue.destinationViewController;
        vcNoticeDetail.noticeParam = sender;
    }
    
}

#pragma mark - navigation 

- (void)toAuthorDetailWithAuthor:(MZLModelUser *)user {
    MZLAuthorDetailViewController *vcAuthor = [MZL_MAIN_STORYBOARD() instantiateViewControllerWithIdentifier:NSStringFromClass([MZLAuthorDetailViewController class])];
    MZLModelAuthor *author = [user toAuthor];
    vcAuthor.authorParam = author;
    [self.navigationController pushViewController:vcAuthor animated:YES];
}

- (void)toArticleDetailWithArticle:(MZLModelArticle *)article {
    MZLArticleDetailViewController *vcArticleDetail = [MZL_MAIN_STORYBOARD() instantiateViewControllerWithIdentifier:NSStringFromClass([MZLArticleDetailViewController class])];
    vcArticleDetail.articleParam = article;
    [self.navigationController pushViewController:vcArticleDetail animated:YES];
}

- (void)toLocationDetailWithLocation:(MZLModelLocationBase *)location {
    [self toLocationDetail:location selectedIndex:MZL_LOCATION_DETAIL_ARTICLES_SECTION];
}

- (void)toLocationDetail:(MZLModelLocationBase *)location selectedIndex:(NSInteger)selectedIndex {
    MZLLocationDetailViewController * vcLocDetail = [MZL_MAIN_STORYBOARD() instantiateViewControllerWithIdentifier:NSStringFromClass([MZLLocationDetailViewController class])];
    vcLocDetail.locationParam = location;
    vcLocDetail.selectedIndex = selectedIndex;
    [self.navigationController pushViewController:vcLocDetail animated:YES];
}

- (void)toLocationDetailGoods:(MZLModelLocationBase *)location {
    [self toLocationDetail:location selectedIndex:MZL_LOCATION_DETAIL_GOODS_SECTION];
}

- (void)toLocationDetailLocations:(MZLModelLocationBase *)location {
    [self toLocationDetail:location selectedIndex:MZL_LOCATION_DETAIL_LOCATIONS_SECTION];
}

- (void)toShortArticleDetailWithShortArticle:(MZLModelShortArticle *)shortArticle {
    [self toShortArticleDetailWithShortArticle:shortArticle commentFlag:NO];
}

- (void)toShortArticleDetailWithShortArticle:(MZLModelShortArticle *)shortArticle commentFlag:(BOOL)flag {
    MZLShortArticleDetailVC *vcShortArticle = [MZL_SHORT_ARTICLE_STORYBOARD() instantiateViewControllerWithIdentifier:NSStringFromClass([MZLShortArticleDetailVC class])];
    vcShortArticle.shortArticle = shortArticle;
    vcShortArticle.popupCommentOnViewAppear = flag;
    vcShortArticle.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcShortArticle animated:YES];
}

#pragma mark - ID for statistics

- (NSString *)statsID {
    return nil;
}

//#pragma mark - orientation
//
//- (NSUInteger)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (BOOL)shouldAutorotate {
//    return NO;
//}

@end
