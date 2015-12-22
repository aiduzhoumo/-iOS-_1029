//
//  MZLPersonalizedShortArticleVC.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-2-4.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLPersonalizedShortArticleVC.h"
#import <IBMessageCenter.h>
#import "MZLBaseViewController+CityList.h"
#import "MZLFilterParam.h"
#import "MZLServices.h"
//#import "MZLShortArticleCell.h"
#import "MZLShortArticleCellStyle2.h"
#import "MZLModelArticle.h"
#import "MZLModelNotice.h"
#import "MZLModelShortArticle.h"
#import "MZLArticleDetailViewController.h"
#import "MZLNoticeDetailViewController.h"
#import "MZLShortArticleDetailVC.h"
#import "MZLSplashViewController.h"

@interface MZLPersonalizedShortArticleVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tvPerShortArticle;

@end

@implementation MZLPersonalizedShortArticleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *userInfo = [MZLSharedData getApnsInfoForNotification];
    UIStoryboard *sb = MZL_MAIN_STORYBOARD();
    UIViewController *targetVc;
    
    if ([[userInfo valueForKey:@"article"] valueForKey:@"id"]) {
        MZLModelArticle *article = [[MZLModelArticle alloc] init];
        article.identifier = [[[userInfo valueForKey:@"article"] valueForKey:@"id"] intValue];
        MZLArticleDetailViewController * vcArticleDetail = (MZLArticleDetailViewController *) [sb instantiateViewControllerWithIdentifier:NSStringFromClass([MZLArticleDetailViewController class])];
        vcArticleDetail.articleParam = article;
        targetVc = vcArticleDetail;
    }
    else if([[userInfo valueForKey:@"notice"] valueForKey:@"id"]) {
        MZLModelNotice *notice = [[MZLModelNotice alloc] init];
        notice.identifier = [[[userInfo valueForKey:@"notice"] valueForKey:@"id"] intValue];
        MZLNoticeDetailViewController * vcNoticeDetail = (MZLNoticeDetailViewController *) [sb instantiateViewControllerWithIdentifier:NSStringFromClass([MZLNoticeDetailViewController class])];
        vcNoticeDetail.noticeParam = notice;
        targetVc = vcNoticeDetail;
    }
    else if ([[userInfo valueForKey:@"short_article"] valueForKey:@"id"]) {
        MZLModelShortArticle *shortArticle = [[MZLModelShortArticle alloc] init];
        shortArticle.identifier = [[[userInfo valueForKey:@"short_article"] valueForKey:@"id"] intValue];
        MZLShortArticleDetailVC *vcShortArticle = [MZL_SHORT_ARTICLE_STORYBOARD() instantiateViewControllerWithIdentifier:NSStringFromClass([MZLShortArticleDetailVC class])];
        vcShortArticle.shortArticle = shortArticle;
        vcShortArticle.popupCommentOnViewAppear = NO;
        vcShortArticle.hidesBottomBarWhenPushed = YES;
        targetVc = vcShortArticle;
    }
    if (targetVc) {
        [self mzl_pushViewController:targetVc];
        [MZLSharedData removeApnsinfoForNotification];
    }

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
  }

- (void)mzl_pushViewController:(UIViewController *)vc {
    // 一般来说，所有的vc都由splashVc模态展示，除非该vc再被其它vc模态展示
    if (! [self.presentingViewController isKindOfClass:[MZLSplashViewController class]]) {
        UIViewController *presentingVc = self.presentingViewController;
        __weak UINavigationController *navVc;
        if ([presentingVc isKindOfClass:[UITabBarController class]]) {
            navVc = (UINavigationController *)(((UITabBarController *)presentingVc).selectedViewController);
        } else if ([presentingVc isKindOfClass:[UINavigationController class]]) {
            navVc = (UINavigationController *)presentingVc;
        } else {
            navVc = presentingVc.navigationController;
        }
        [presentingVc dismissViewControllerAnimated:YES completion:^{
            [navVc pushViewController:vc animated:YES];
        }];
        return;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - protected override

- (NSArray *)noRecordTextsWithFilters {
    return @[@"对不起啊，", @"没有找到你个性化需求的玩法，", @"请重新选择。"];
}

- (void)_mzl_homeInternalInit {
    self.title = @"玩法";
    _tv = self.tvPerShortArticle;
    _tv.backgroundColor = @"EFEFF4".co_toHexColor;
    _tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tv removeUnnecessarySeparators];
    [self addCityListDropdownBarButtonItem];
}

#pragma mark - protected for load

- (void)_loadModelsWithoutFilters {
    NSArray *params = [self serviceParamsFromFilter:nil paging:nil];
    if (! params) {
        return;
    }
    [self invokeService:@selector(personalizeShortArticleServiceWithFilter:pagingParam:succBlock:errorBlock:) params:params];
}

- (void)_loadModelsWithFilters:(MZLFilterParam *)filter {
    NSArray *params = [self serviceParamsFromFilter:filter paging:nil];
    if (! params) {
        return;
    }
    [self invokeService:@selector(personalizeShortArticleServiceWithFilter:pagingParam:succBlock:errorBlock:) params:params];
}

#pragma mark - protected for load more

- (BOOL)_canLoadMore {
    return YES;
}

- (void)_loadMoreWithoutFilters:(MZLPagingSvcParam *)pagingParam {
    NSArray *params = [self serviceParamsFromFilter:nil paging:pagingParam];
    if (! params) {
        return;
    }
    [self invokeLoadMoreService:@selector(personalizeShortArticleServiceWithFilter:pagingParam:succBlock:errorBlock:) params:params];
}

- (void)_loadMoreWithFilters:(MZLFilterParam *)filter {
    NSArray *params = [self serviceParamsFromFilter:filter paging:nil];
    if (! params) {
        return;
    }
    [self invokeLoadMoreService:@selector(personalizeShortArticleServiceWithFilter:pagingParam:succBlock:errorBlock:) params:params];
}

#pragma mark - table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLShortArticleCellStyle2 *cell = [MZLShortArticleCellStyle2 cellWithTableview:tableView model:_models[indexPath.row]];
    return cell;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MZLShortArticleCellStyle2 heightForTableView:tableView withModel:_models[indexPath.row]];
}

#pragma mark - statsID

- (NSString *)statsID {
    return @"短文玩法列表";
}

#pragma mark - misc

- (NSArray *)serviceParamsFromFilter:(MZLFilterParam *)filter paging:(MZLPagingSvcParam *)paging {
    if ([self checkAndShowCityListOnLocationNotDetermined]) {
        return nil;
    }
    MZLFilterParam *paramFilter = filter;
    if (! paramFilter) {
        paramFilter = [[MZLFilterParam alloc] init];
    }
    paramFilter.destinationName = [MZLSharedData selectedCity];
    MZLPagingSvcParam *paramPaging = paging;
    if (! paramPaging) {
        paramPaging = [self pagingParamFromModels];
    }
    return @[paramFilter, paramPaging];
}

- (void)dealloc {

}

@end
