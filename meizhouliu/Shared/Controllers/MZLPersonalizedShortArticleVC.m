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
#import "UIView+MZLAdditions.h"
#import "MZLLoginViewController.h"
#import "MZLTabBarViewController.h"
#import "COPreferences.h"

@interface MZLPersonalizedShortArticleVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tvPerShortArticle;

@property (nonatomic, weak) UIButton *hotBtn;
@property (nonatomic, weak) UIButton *attentionBtn;
@property (nonatomic, weak) UIView *btnBottomView;

//记录当前点击的是不是热门按钮
@property (nonatomic, assign) BOOL isHot;

//记录pop回来的时候会刷新数据
@property (nonatomic, assign) int m;
@end

@implementation MZLPersonalizedShortArticleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHot = YES;
    self.m = 0;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    UIButton *hotBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [hotBtn setTitle:@"热门" forState:UIControlStateNormal];
    hotBtn.titleLabel.font = MZL_BOLD_FONT(16);
    [hotBtn setTitleColor:@"434343".co_toHexColor forState:UIControlStateNormal];
    [hotBtn addTarget:self action:@selector(hotArticleCheck) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:hotBtn];
    self.hotBtn = hotBtn;
    
    UIView *btnBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 80, 4)];
    btnBottomView.backgroundColor = @"FFD414".co_toHexColor;
    [titleView addSubview:btnBottomView];
    self.btnBottomView = btnBottomView;
    
    UIButton *attentionBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 0, 80, 44)];
    [attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    attentionBtn.titleLabel.font = MZL_BOLD_FONT(16);
    [attentionBtn setTitleColor:@"999999".co_toHexColor forState:UIControlStateNormal];
    [attentionBtn addTarget:self action:@selector(AttentionListCheck) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:attentionBtn];
    self.attentionBtn = attentionBtn;

    self.navigationItem.titleView = titleView;

    //通过推送内容进入的app
    [self getIntoAppFromApns];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self hideFilterView];
    self.m = 1;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [self hotArticleCheck];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
    //pop回来的时候需要刷新
    if (self.m != 0) {
        self.m = 0 ;
        [self loadModels];
    }
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

#pragma mark - apns
- (void)getIntoAppFromApns {
    NSDictionary *userInfo = [MZLSharedData getApnsInfoForNotification];
    [MZLSharedData removeApnsinfoForNotification];
    
    if (userInfo == nil) {
        return;
    }
    
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
    
        if ([userInfo valueForKey:@"anchor"]) {
            vcShortArticle.scrollToTheSpecificComment = YES;
            NSString *temp = [[[userInfo valueForKey:@"anchor"] valueForKey:@"short_articles_comment"] valueForKey:@"id"];
            vcShortArticle.commentIdentifier = [temp integerValue];
        }
    
        targetVc = vcShortArticle;
    }
   
    if (targetVc) {
        [self mzl_pushViewController:targetVc];
    }
}

#pragma mark - 页面切换
- (void)hotArticleCheck {
    //显示fiterView
    [self showFilterView];
    self.isHot = YES;
    
    _hotBtn.enabled = NO;
    _attentionBtn.enabled = YES;
    
    _hotBtn.titleLabel.font = MZL_BOLD_FONT(16);
    [_hotBtn setTitleColor:@"434343".co_toHexColor forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.btnBottomView.frame = CGRectMake(0, 40, 80, 4);
    } completion:^(BOOL finished) {
    }];
    
    _attentionBtn.titleLabel.font = MZL_BOLD_FONT(16);
    [_attentionBtn setTitleColor:@"999999".co_toHexColor forState:UIControlStateNormal];
    
    [self reset];
    [self showNetworkProgressIndicator];
    [self loadModels];
}

- (void)AttentionListCheck {
    // 必须先登录
    if (! [MZLSharedData isAppUserLogined]) {
        MZLTabBarViewController *tabVC = (MZLTabBarViewController *)self.tabBarController;
        [tabVC showMzlTabBar:NO animatedFlag:NO];
        __weak MZLPersonalizedShortArticleVC *weakSelf = self;
        [self popupLoginFrom:MZLLoginPopupFromShortArticle executionBlockWhenDismissed:^{
            if ([MZLSharedData isAppUserLogined]) {
                [weakSelf toAttentionView];
            }
        }];
    } else {
        [self toAttentionView];
    }
}


- (void)toAttentionView {

    self.isHot = NO;
    [self showNetworkProgressIndicator];
    
    _attentionBtn.enabled = NO;
    _hotBtn.enabled = YES;
    
    _hotBtn.titleLabel.font = MZL_BOLD_FONT(16);
    [_hotBtn setTitleColor:@"999999".co_toHexColor forState:UIControlStateNormal];
    
    [self reset];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.btnBottomView.frame = CGRectMake(80, 40, 80, 4);
    } completion:^(BOOL finished) {
    }];
    
    _attentionBtn.titleLabel.font = MZL_BOLD_FONT(16);
    [_attentionBtn setTitleColor:@"434343".co_toHexColor forState:UIControlStateNormal];
    
    MZLPagingSvcParam *param = [MZLPagingSvcParam pagingSvcParamWithPageIndex:1 fetchCount:10];
    [MZLServices followDaRenListWithPagingParam:param succBlock:^(NSArray *models) {
        
        [self checkForAttentionList:models];
        
    } errorBlock:^(NSError *error) {
        [self onNetworkError];
    }];

}

- (void)checkForAttentionList:(NSArray *)models {
    if (models.count == 0) {
        [self hideProgressIndicator];
        [_tv removeUnnecessarySeparators];
        [self noAttentionRecordView];
    }else {
    // 刷新页面
        [self loadModels];
        //临时测数据
//        [self hideProgressIndicator];
//        [_tv removeUnnecessarySeparators];
//        [self noAttentionRecordView];
    }

}

#pragma mark - 原版搬过来,解决models为0,显示有按钮的recordView
- (void)createTipViewOnLoadSucc {
   
    if (_models.count == 0 ) {
        if (_isHot) {
            [_tv removeUnnecessarySeparators];
            [self noRecordView];
        }else{
            [_tv removeUnnecessarySeparators];
            [self noAttentionRecordView];
        }
        return;
    }
    // 有多个sections的暂不支持load more操作
    if (_isMultiSections) {
        return;
    }
    if ([self canLoadMore]) {
        [self createFooterPullToRefreshView];
    } else {
        [self createFooterSpacingView];
    }
}

- (BOOL)canLoadMore {
    if (_hasMore && ! _loadingMore && _models.count > 0) {
        return [self _canLoadMore];
    }
    return NO;
}

- (void)createFooterPullToRefreshView {
    UIView *footerPullToRefreshView = [self footerPullToRefreshView];
    if (footerPullToRefreshView) {
        _tv.tableFooterView = footerPullToRefreshView;
    }
}

- (void)createFooterSpacingView {
    UIView *view = [self footerSpacingView];
    if (view) {
        _tv.tableFooterView = view;
    }
}

- (UIView *)footerPullToRefreshView {
    UIView *view = [_tv labelsView:[self footerPullToRefreshViewText]];
    return view;
}

- (NSArray *)footerPullToRefreshViewText {
    return @[MZL_TABLEVIEW_FOOTER_PULL_TO_REFRESH];
}

#pragma mark - protected override

- (NSArray *)noRecordTextsWithFilters {
    return @[@"对不起啊，", @"没有找到你个性化需求的玩法，", @"请重新选择。"];
}

- (void)_mzl_homeInternalInit {
//    self.title = @"玩法";
    _tv = self.tvPerShortArticle;
    _tv.backgroundColor = @"EFEFF4".co_toHexColor;
    _tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tv removeUnnecessarySeparators];
    [self addCityListDropdownBarButtonItem];
}

#pragma mark - 取得_models
- (void)onLoadSuccBlock:(NSArray *)modelsFromSvc {
    //需要判断有没有登入
    if (![MZLSharedData isAppUserLogined]) {
        [self hideProgressIndicator];
        _loading = NO;
        [self handleModelsOnLoad:modelsFromSvc];
        [self createTipViewOnLoadSucc];
        [self _onLoadSuccBlock:modelsFromSvc];
        [_tv reloadData];
    }else {
//        [self hideProgressIndicator];
//        _loading = NO;
        [self handleModelsOnLoad:modelsFromSvc];
//        [self createTipViewOnLoadSucc];
        [self _onLoadSuccBlock:modelsFromSvc];
        //进行判断哪些是被关注过的，在刷新数据
        [self getAttentionInfosFromModels:modelsFromSvc];
    }
}

- (void)getAttentionInfosFromModels:(NSArray *)modelsFromSvc {
    
    NSMutableString *mutStr = [NSMutableString string];
    for (MZLModelShortArticle *s in modelsFromSvc) {
        NSInteger i = s.author.identifier;
        [mutStr appendString:[NSString stringWithFormat:@"%ld,",i]];
    }
    //进行判断，那些是被关注过的
    [MZLServices fitterOfAttentionForUser:mutStr SuccBlock:^(NSArray *models) {
        
        NSMutableArray *numArr = [NSMutableArray array];
        for (NSNumber *n in models) {
            [numArr addObject:[NSString stringWithFormat:@"%@",n]];
        }
        
        //加数组不用set。用add
        [MZLSharedData addIdArrayIntoAttentionIds:numArr];
        
        [self hideProgressIndicator];
        _loading = NO;
        [self createTipViewOnLoadSucc];
        [_tv reloadData];
    } errorBlobk:^(NSError *error) {
        [self onNetworkError];
    }];
}

- (void)handleModelsOnLoad:(NSArray *)modelsFromSvc {
    _isMultiSections = NO;
    _models = [self mapModelsOnLoad:modelsFromSvc];
    _hasMore = (_models.count >= [self pageFetchCount]);
}

#pragma mark - 取得更多model
- (void)onLoadMoreSuccBlock:(NSArray *)modelsFromSvc {
    if (![MZLSharedData isAppUserLogined]) {
        [self onLoadMoreFinished];
        [self handleModelsOnLoadMore:modelsFromSvc];
        [self createTipViewOnLoadMoreSucc];
        [self _onLoadMoreSuccBlock:modelsFromSvc];
        [_tv reloadData];
    }else{
        //应该跟以前是不变的，但是刷新_tv必须要在判断以后
//        [self onLoadMoreFinished];
        [self handleModelsOnLoadMore:modelsFromSvc];
        [self createTipViewOnLoadMoreSucc];
        [self _onLoadMoreSuccBlock:modelsFromSvc];
        //进行判断哪些是被关注了的
        [self getAttentionIfonsFromMoreModels:modelsFromSvc];
    }
}

- (void)getAttentionIfonsFromMoreModels:(NSArray *)modelsFromSvc {
    
    NSMutableString *mutString = [[NSMutableString alloc] init];
    for (MZLModelShortArticle *s in modelsFromSvc) {
        NSInteger i = s.author.identifier;
        [mutString appendString:[NSString stringWithFormat:@"%ld,",i]];
    }
    //进行判断，那些是被关注过的
    [MZLServices fitterOfAttentionForUser:mutString SuccBlock:^(NSArray *models) {
        
        NSMutableArray *numArr = [NSMutableArray array];
        for (NSNumber *n in models) {
            [numArr addObject:[NSString stringWithFormat:@"%@",n]];
        }
        [MZLSharedData addIdArrayIntoAttentionIds:numArr];
                
        [self onLoadMoreFinished];
        [_tv reloadData];
    } errorBlobk:^(NSError *error) {
        [self onNetworkError];
    }];

}

- (void)createTipViewOnLoadMoreSucc {
    if (_isMultiSections) { // 有多个sections的暂不支持这一操作
        return;
    }
    if ([self canLoadMore]) {
        [self createFooterPullToRefreshView];
    } else {
        [self createFooterSpacingView];
    }
}


- (void)onLoadMoreFinished {
    _loadingMore = NO;
    _loadMoreOp = nil;
    //    [self resetScrollState];
}

- (NSArray *)handleModelsOnLoadMore:(NSArray *)modelsFromSvc {
    NSArray *mappedModels = [self mapModelsOnLoadMore:modelsFromSvc];
    if (mappedModels.count > 0) {
        [_models addObjectsFromArray:mappedModels];
    }
    _hasMore = mappedModels.count >= [self pageFetchCount];
    return mappedModels;
}

#pragma mark - protected for load

- (void)_loadModelsWithoutFilters {
    NSArray *params = [self serviceParamsFromFilter:nil paging:nil];
    if (! params) {
        return;
    }
    if (self.isHot) {
        [self invokeService:@selector(personalizeShortArticleServiceWithFilter:pagingParam:succBlock:errorBlock:) params:params];
    }else {
        [self invokeService:@selector(followDarenShortArticleServiceWithFilter:pagingParam:succBlock:errorBlock:) params:params];
    }
}

- (void)_loadModelsWithFilters:(MZLFilterParam *)filter {
    NSArray *params = [self serviceParamsFromFilter:filter paging:nil];
    if (! params) {
        return;
    }
    if (self.isHot) {
        [self invokeService:@selector(personalizeShortArticleServiceWithFilter:pagingParam:succBlock:errorBlock:) params:params];
    }else {
        [self invokeService:@selector(followDarenShortArticleServiceWithFilter:pagingParam:succBlock:errorBlock:) params:params];
    }
    
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
    if (self.isHot) {
        [self invokeLoadMoreService:@selector(personalizeShortArticleServiceWithFilter:pagingParam:succBlock:errorBlock:) params:params];
    }else {
        [self invokeLoadMoreService:@selector(followDarenShortArticleServiceWithFilter:pagingParam:succBlock:errorBlock:) params:params];

    }
    
}

- (void)_loadMoreWithFilters:(MZLFilterParam *)filter {
    NSArray *params = [self serviceParamsFromFilter:filter paging:nil];
    if (! params) {
        return;
    }
    if (self.isHot) {
        [self invokeLoadMoreService:@selector(personalizeShortArticleServiceWithFilter:pagingParam:succBlock:errorBlock:) params:params];
    }else {
        [self invokeLoadMoreService:@selector(followDarenShortArticleServiceWithFilter:pagingParam:succBlock:errorBlock:) params:params];
    }
    
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

@end








