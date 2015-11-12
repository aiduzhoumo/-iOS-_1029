//
//  MZLArticleDetailViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-12.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLArticleDetailViewController.h"
#import "MZLArticleDetailNavVwController.h"
#import "WebViewJavascriptBridge.h"
#import "WeView.h"
#import "MZLLocationHeaderInfo.h"
#import "MZLLocationHeaderView.h"
#import "MZLLocationHeaderContainer.h"
#import "JDStatusBarNotification.h"
#import "UIBarButtonItem+COAdditions.h"
#import <ShareSDK/ShareSDK.h>
#import "MZLServices.h"
#import "MZLModelArticle.h"
#import "MZLModelArticleDetail.h"
#import "MZLUserFavoredArticleResponse.h"
#import "MZLUserLocPrefResponse.h"
#import "MZLModelUserFavoredArticle.h"
#import "MZLModelLocation.h"
#import "MZLModelRouteInfo.h"
#import "UIView+MBProgressHUDAdditions.h"
#import "MZLLocationRouteInfo.h"
#import "MobClick.h"
#import "NSString+MZLImageURL.h"
#import "MZLArticleDetailPOINavVwController.h"
#import "MZLLoginSvcParam.h"
#import "MZLRegLoginResponse.h"
#import "MZLServiceResponseDetail.h"
#import "MZLLoginViewController.h"
#import "UIViewController+MZLAdditions.h"
#import <IBMessageCenter.h>
#import "MZLArticleCommentViewController.h"
#import "NSError+CONetwork.h"
#import <TencentOpenAPI/QQApi.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "MZLGoodsListViewController.h"
#import "MZLGoodsDetailViewController.h"

#define TOP_BAR_HEIGHT 64.0
#define INTERVAL_UDPATE_LOCATION_HEADERS 0.1
#define SECONDS_IN_A_DAY 86400.0

#define MZL_ADVIEW_DISMISS_TIMEOUT 5.0

#define SEGUE_TOCOMMENT @"toComment"
#define SEGUE_TOGOODS @"toGoods"

typedef NS_ENUM(NSInteger, MZLADServiceStatus) {
    MZLADServiceStatusInitialLoad = 0,
    MZLADServiceStatusDataRefresh   = 1
};

@interface MZLArticleDetailViewController () {
    MZLArticleDetailNavVwController *_childVwController;
    NSMutableArray *_locationHeaders;
    BOOL _isCaptureScrollEvent;
    
    MZLADServiceStatus _serviceStatus;
    NSInteger _successServiceCallCount;
    NSInteger _finishedServiceCallCount;
    BOOL _shouldRefreshData;
    
    UIBarButtonItem *_favorBtn;
    UIBarButtonItem *_commentBtn;
    UILabel *_lblCount;
    UIView *_vwComment;
    UIView *_vwGoods;
    UIBarButtonItem *_goodsBtn;
    
    MZLModelArticleDetail *_articleDetail;
    MZLModelUserFavoredArticle *_favored;
    NSMutableArray *_favoredLocations;
    WebViewJavascriptBridge *_bridge;
    
    BOOL _isUpdateLocHeadersInQueue;
    NSMutableArray *_tempLocHeaderInfos;
    
    NSTimer *_timer;
    NSTimer *_adTimer;
    
    NSString *_errorUrl;
    NSString *_goodsId;
    NSArray *_goodsList;
    
}

@end

@implementation MZLArticleDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.vwChild.userInteractionEnabled = NO;
    
    [self getArticleInfo];
    [iRate sharedInstance].delegate = self;
}

- (void)dealloc {
    [IBMessageCenter removeMessageListenersForTarget:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_shouldRefreshData) {
        [self dataRefresh];
        _shouldRefreshData = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    // 考虑从模态的导航界面返回，不需要调用父类的逻辑
    if (! [self isChildViewVisible]) {
        [super viewDidAppear:animated];
    }
    [self scrollToTargetLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 恢复默认
//    [[UINavigationBar appearance] setBackgroundImage:MZL_NAVBAR_BG_IMAGE() forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:MZL_SEGUE_TOPOINAV]) {
        MZLArticleDetailPOINavVwController *dest = (MZLArticleDetailPOINavVwController *)segue.destinationViewController;
        dest.articleCtrl = _childVwController;
        [dest setAnnotations:[_childVwController getAnnotations]];
        [dest setSelectedLocation:[_childVwController getSelectedLocation]];
    } else if ([segue.identifier isEqualToString:SEGUE_TOCOMMENT]) {
        MZLArticleCommentViewController *dest = (MZLArticleCommentViewController *)segue.destinationViewController;
        dest.article = _articleDetail;
        dest.articleDetailViewController = self;
    }else if ([segue.identifier isEqualToString:SEGUE_TOGOODS]) {
        MZLGoodsListViewController *dest = (MZLGoodsListViewController *)segue.destinationViewController;
        dest.article = _articleDetail;
    }else if ([segue.identifier isEqualToString:MZL_SEGUE_TOGOODSDETAIL]) {
        MZLGoodsDetailViewController *dest = (MZLGoodsDetailViewController *)segue.destinationViewController;
        dest.goodsUrl = sender;
    }
}

- (void)toAuthorDetail {
    [self performSegueWithIdentifier:MZL_SEGUE_TOAUTHORDETAIL sender:_articleDetail.author];
    [MobClick event:@"clickArticleDetailAuthor"];
}

- (void)toTrips {
    _childVwController.targetLocationRouteInfo = nil;
    if (_locationHeaders.count == 0) {
        [UIAlertView showAlertMessage:@"该玩法暂时还没有玩法路线哟！"];
        return;
    }
    [self showChildVwController];
}

- (void)toComment {
    [self performSegueWithIdentifier:SEGUE_TOCOMMENT sender:nil];
}

- (void)toGoods {
    [self performSegueWithIdentifier:SEGUE_TOGOODS sender:nil];
}

- (void)toGoodsDetail {
    NSString *_goodsUrl = [NSString stringWithFormat:@"http://www.meizhouliu.com/articles/%@/products/%@",@(_articleDetail.identifier),_goodsId];
    [self performSegueWithIdentifier:MZL_SEGUE_TOGOODSDETAIL sender:_goodsUrl];
}

#pragma mark - init

- (UIBarButtonItem *)fixedSpaceItem {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 6.0, 24.0)];
    return [[UIBarButtonItem alloc]initWithCustomView:view];
}

- (NSString *)favorImageName {
    return [self imageNameForFavoredArticle:_favored];
}

- (void)toggleFavorImage {
    UIButton *innerBtn = (UIButton *)_favorBtn.customView;
    [innerBtn setImage:[UIImage imageNamed:[self favorImageName]] forState:UIControlStateNormal];
}

- (void)createFavorButtonItem {
    _favorBtn = [UIBarButtonItem itemWithSize:MZL_BARBUTTONITEM_SIZE imageName:[self favorImageName] target:self action:@selector(favor)];
}

- (void)createGoodsButtonItem {
    _vwGoods = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 32.0, 24.0)];
    UIButton *btnGoods = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 24.0, 24.0)];
    [btnGoods setBackgroundImage:[UIImage imageNamed:@"Goods_Car"] forState:UIControlStateNormal];
    UILabel *_goodsCounts = [[UILabel alloc] initWithFrame:CGRectMake(22.0, -2.0,16.0, 24.0)];
    [_vwGoods addSubview:_goodsCounts];
    [_vwGoods addSubview:btnGoods];
    [_vwGoods addTapGestureRecognizer:self action:@selector(toGoods)];
    [btnGoods addTarget:self action:@selector(toGoods) forControlEvents:UIControlEventTouchUpInside];
    _goodsBtn = [[UIBarButtonItem alloc]initWithCustomView:_vwGoods];
    [_goodsCounts setTextColor:colorWithHexString(@"#b9b9b9")];
    _goodsCounts.font = MZL_BOLD_FONT(14.0);
    _goodsCounts.textAlignment = NSTextAlignmentCenter;
    _goodsCounts.text = [NSString stringWithFormat:@"%@",@(_goodsList.count)];
    
}



- (void)updateCommentCount:(NSInteger)changeCount {
    NSInteger commentCount = _articleDetail.commentCount + changeCount;
    _articleDetail.commentCount = commentCount;
    if (commentCount < 0) {
        commentCount = 0;
    }
//    UIButton *innerBtn = (UIButton *)_commentCount.customView;
    if (commentCount == 0) {
//        [innerBtn setBackgroundImage:[UIImage imageNamed:@"No_Comment"] forState:UIControlStateNormal];
        [_lblCount setText:@""];
        _vwComment.frame = CGRectMake(0.0, 0.0, 24.0, 24.0);
//        [_vwComment layoutIfNeeded];
    } else {
//        [innerBtn setBackgroundImage:[UIImage imageNamed:@"Comment"] forState:UIControlStateNormal];
        if (commentCount > 99) {
            [_lblCount setText:@"99+"];
        } else {
            [_lblCount setText:INT_TO_STR(commentCount)];
        }
    }
}

- (void)updateCommentCount {
    [self updateCommentCount:0];
}

- (void)createCommentButtonItem {

    _vwComment = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 32.0, 24.0)];
    UIButton *btnComment = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 24.0, 24.0)];
    [btnComment setBackgroundImage:[UIImage imageNamed:@"Comment"] forState:UIControlStateNormal];
    _lblCount = [[UILabel alloc] initWithFrame:CGRectMake(22.0, -2.0,16.0, 24.0)];
    [_vwComment addSubview:_lblCount];
    [_vwComment addSubview:btnComment];
    [_vwComment addTapGestureRecognizer:self action:@selector(toComment)];
    [btnComment addTarget:self action:@selector(toComment) forControlEvents:UIControlEventTouchUpInside];
    _commentBtn = [[UIBarButtonItem alloc]initWithCustomView:_vwComment];
    
    [_lblCount setTextColor:colorWithHexString(@"#b9b9b9")];
    _lblCount.font = MZL_BOLD_FONT(14.0);
    _lblCount.textAlignment = NSTextAlignmentCenter;
    [self updateCommentCount];
}

- (void)initNavItems {
//    [self createFavorButtonItem];
    [self createCommentButtonItem];
    NSMutableArray *barItems = co_emptyMutableArray();
    if ([WXApi isWXAppInstalled] || [WeiboSDK isWeiboAppInstalled] || [QQApi isQQInstalled]) {
        UIBarButtonItem *shareButton = [UIBarButtonItem itemWithSize:MZL_BARBUTTONITEM_SIZE imageName:@"Share" target:self action:@selector(share)];
        [barItems addObjectsFromArray:@[shareButton, [self fixedSpaceItem]]];
    }
    [barItems addObjectsFromArray:@[_commentBtn]];
    if (_goodsList.count > 0) {
        [self createGoodsButtonItem];
        [barItems addObjectsFromArray:@[[self fixedSpaceItem], _goodsBtn]];
    }
    self.navigationItem.rightBarButtonItems = barItems;
}

- (void)initWeb {
    [self showNetworkProgressIndicator:MZL_MSG_LOAD_ARTICLE];
    
    self.wvArticleContent.scrollView.delegate = self;
    self.wvArticleContent.scrollView.scrollsToTop = YES;

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: webUrl(_articleDetail.articleUrl)];
    self.wvArticleContent.delegate = self;
    [self.wvArticleContent loadRequest:request];
    
//    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.wvArticleContent webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {}];
    __weak MZLArticleDetailViewController * weakSelf = self;
    [_bridge registerHandler:@"toAuthorDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf toAuthorDetail];
    }];
    [_bridge registerHandler:@"toTrips" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf toTrips];
        [MobClick event:@"clickArticleDetailCheckRoute"];
        [MobClick event:@"clickArticleDetailSidebar"];
    }];
    [_bridge registerHandler:@"onDestinationsReady" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"onDestReady, %@", data);
        [weakSelf onDestionationsInfoUpdated:data];
    }];
    
    [_bridge registerHandler:@"toGoodsDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
        _goodsId = data;
        [weakSelf toGoodsDetail];
    }];
}

- (void)initAdView{
    self.wvAdVContent.scrollView.scrollsToTop = NO;
    if ([self shouldShowAdView]) {
        _adTimer = [NSTimer scheduledTimerWithTimeInterval:MZL_ADVIEW_DISMISS_TIMEOUT target:self selector:@selector(dismissAdView:) userInfo:nil repeats:NO];
        NSString *strUrl = [MZLSharedData youmengAdUrl];
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        [self.wvAdVContent loadRequest:request];
    } else {
        [self.wvAdVContent setVisible:NO];
    }
//    [self.wvAdVContent setVisible:NO];
}


- (void)initInternal {
    if (_errorUrl) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:webUrl(_errorUrl)];
        [self.wvArticleContent loadRequest:request];
        [self hideProgressIndicator];
        return;
    }
    
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_LOGINED target:self action:@selector(onLoginStatusModified)];
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_LOGOUT target:self action:@selector(onLoginStatusModified)];
    
    [self initTimer];
    [self initWeb];
    [self initAdView];
    
//    UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc]initWithTarget:self
//                                                                             action:@selector(showChildVwController)];
//    sgr.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.wvArticleContent addGestureRecognizer:sgr];
}

- (void)initChildViewController {
    _childVwController = [[MZLArticleDetailNavVwController alloc]init];
    _childVwController.article = _articleDetail;
    _childVwController.favoredLocations = _favoredLocations;
    _favoredLocations = nil;
}

#pragma mark - service call (initial service)

- (void)resetServiceFlags {
    _successServiceCallCount = 0;
    _finishedServiceCallCount = 0;
    _errorUrl = nil;
}

- (void)getArticleInfo {
    [self resetServiceFlags];
    _serviceStatus = MZLADServiceStatusInitialLoad;
    [self.view showProgressIndicator:MZL_MSG_LOADING message:nil isUseWindowForDisplay:NO];
    [self getArticleGoods];
    [self getArticleDetail];
    [self getArticleFavordStatus];
    [self getArticleFavoredLocations];
}

- (void)getArticleDetail {
    [MZLServices articleDetailService:self.articleParam succBlock:^(NSArray *models) {
        [self onArticleDetailSucceed:models];
    } errorBlock:^(NSError *error) {
        [self onServiceError:error];
    }];
}

- (void)onArticleDetailSucceed:(NSArray *)models {
    _articleDetail = models[0];
    [self onServiceSucceed];
}

- (void)getArticleGoods {
    [MZLServices goodsInArticle:_articleParam succBlock:^(NSArray *models) {
        _goodsList = models;
    } errorBlock:^(NSError *error) {
        [self onServiceError:error];
    }];
}
- (void)getArticleFavordStatus {
    [MZLServices isArticleFavored:self.articleParam succBlock:^(NSArray *models) {
        [self onArticleFavordStatusSucceed:models];
    } errorBlock:^(NSError *error) {
        [self onServiceError:error];
    }];
}

- (void)onArticleFavordStatusSucceed:(NSArray *)models {
    MZLUserFavoredArticleResponse *response = models[0];
    if (response.error == 0) {
        _favored = response.userFavoredArticle;
    } else {
        _favored = nil;
    }
    [self onServiceSucceed];
}

- (void)getArticleFavoredLocations {
    [MZLServices favoredLocationsInArticle:self.articleParam succBlock:^(NSArray *models) {
        [self onArticleFavoredLocationsSucceed:models];
    } errorBlock:^(NSError *error) {
        [self onServiceError:error];
    }];
}

- (void)onArticleFavoredLocationsSucceed:(NSArray *)models {
    MZLUserLocPrefResponse *response = models[0];
    _favoredLocations = [NSMutableArray arrayWithArray:response.userLocationPrefs];
    [self onServiceSucceed];
}

- (void)onServiceSucceed {
    _successServiceCallCount ++;
    [self onServiceFinished];
}

- (void)onServiceError:(NSError *)error {
    [self handleResponseError:error];
    [self onServiceFinished];
}

- (void)onServiceFinished {
    _finishedServiceCallCount ++;
    NSInteger totalServiceCount = 3;
    if (_serviceStatus == MZLADServiceStatusDataRefresh) {
        totalServiceCount = 2;
    }
    if (_finishedServiceCallCount == totalServiceCount) {
        if (_successServiceCallCount < _finishedServiceCallCount) { // 有service失败
            [self onNetworkError];
        } else {
            if (_serviceStatus == MZLADServiceStatusDataRefresh) { // login status 发生变化后调用，界面没有初始化成功不会调用
                [self refreshInterestedLocationsAndFavoredArticles];
            } else {
                [self initInternal];
            }
        }
    }
}

- (void)handleResponseError:(NSError *)error {
    if ([error co_responseStatusCode] == MZL_HTTP_RESPONSECODE_NOTEXIST) { // 404 也认为成功，但是跳转404页面
        _successServiceCallCount ++;
        _errorUrl = [MZLServices urlForCode404];
    }
}

#pragma mark - service call (data fresh, 主要是想去和文章收藏)

- (void)onLoginStatusModified {
    if ([self isTopViewControllerIfInNav]) {
        [self dataRefresh];
    } else {
        _shouldRefreshData = YES;
    }
}

- (void)dataRefresh {
    [self resetServiceFlags];
    _serviceStatus = MZLADServiceStatusDataRefresh;
    [self showNetworkProgressIndicator:MZL_MSG_REFRESHING];
    [self getArticleFavordStatus];
    [self getArticleFavoredLocations];
}

- (void)refreshInterestedLocationsAndFavoredArticles {
    [self hideProgressIndicator];
    // refresh favored locations
    _childVwController.favoredLocations = _favoredLocations;
}

#pragma mark - favor

- (void)favor {
    if (shouldPopupLogin()) {
        [self popupLoginFrom:MZLLoginPopupFromFavoredArticle executionBlockWhenDismissed:nil];
        return;
    }
    [self _favor];
}

- (void)_favor {
    [self showWorkInProgressIndicator];
    if (_favored) {
        [MZLServices removeFavoredArticle:_favored succBlock:^(NSArray *models) {
            [self onFavorServiceSucceed:nil];
        } errorBlock:^(NSError *error) {
            [self onFavorServiceFailed:error];
        }];
    } else {
        [MZLServices addFavoredArticle:self.articleParam.identifier succBlock:^(NSArray *models) {
            [self onFavorServiceSucceed:models[0]];
        } errorBlock:^(NSError *error) {
            [self onFavorServiceFailed:error];
        }];
    }
    [MobClick event:@"clickArticleDetailFavor"];
    [[iRate sharedInstance] promptIfNetworkAvailable];
}

- (void)onFavorServiceSucceed:(MZLUserFavoredArticleResponse *)response {
    [self hideProgressIndicator];
    _favored = response.userFavoredArticle;
    [self toggleFavorImage];
//    NSTimeInterval dismissInterval = MZL_JDSTATUSBAR_DISMISS_INTERVAL;
//    if (response) {
//        [JDStatusBarNotification showWithStatus:@"已添加收藏" dismissAfter:dismissInterval styleName:MZL_JDSTATUSBAR_STYLE1];
//    } else {
//        [JDStatusBarNotification showWithStatus:@"已取消收藏" dismissAfter:dismissInterval styleName:MZL_JDSTATUSBAR_STYLE1];
//    }
}

- (void)onFavorServiceFailed:(NSError *)error {
    [self onPostError:error];
}

#pragma mark - child view related

- (void)showChildVwController {
    [self showChildVwController:_childVwController];
}

- (void)showChildVwController:(UIViewController *)childVwController {
    if ([self isChildViewVisible]) {
        return;
    }
    //1. Add the detail controller as child of the container
    [self addChildViewController:childVwController];
    
    CGRect frame = [self frameForChildController];
    frame.origin.x = CO_SCREEN_WIDTH;
    
    //2. Define the detail controller's view size
    childVwController.view.frame = frame;
    
    //3. Add the Detail controller's view to the Container's detail view and save a reference to the detail View Controller
    [self.vwChild addSubview:childVwController.view];
    
    [UIView animateWithDuration:MZL_ANIMATION_DURATION_DEFAULT
                     animations:^{
                         childVwController.view.frame = [self frameForChildController];
                     }
                     completion:^(BOOL finished) {
                         [self onChildViewAppeared];
                         [childVwController didMoveToParentViewController:self];
                     }];
}

- (CGRect)frameForChildController {
    return self.vwChild.bounds;
}

- (BOOL)isChildViewVisible {
    return self.childViewControllers.count > 0;
}

- (void)onChildViewAppeared {
    self.wvArticleContent.userInteractionEnabled = NO;
    self.vwChild.userInteractionEnabled = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
        item.enabled = NO;
    }
}

- (void)onChildViewDisappeared {
    self.wvArticleContent.userInteractionEnabled = YES;
    self.vwChild.userInteractionEnabled = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
        item.enabled = YES;
    }
}

#pragma mark - scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%f", scrollView.contentOffset.y + TOP_BAR_HEIGHT);
    if (! _isCaptureScrollEvent || _locationHeaders.count == 0) {
        return;
    }
    [self onScrollViewScroll:scrollView];
}

- (void)onScrollViewScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y + TOP_BAR_HEIGHT;
    for (MZLLocationHeaderContainer *container in _locationHeaders) {
        [container handleYPosition:y];
    }
}

#pragma mark - location headers

- (void)onDestionationsInfoUpdated:(id)data {
    NSArray *headersInfo = [self headersInfoFromData:data];
//    if (headersInfo.count == 0) {
//        return;
//    }
    [MZLLocationHeaderContainer adjustHeadersInfo:headersInfo];
    if (_locationHeaders) {
        [self delayUpdateLocationHeaders:headersInfo];
    } else {
        [self onWebViewDidFinishLoadForFirstTime:headersInfo];
    }
}

/** 防止过度刷新界面 */
- (void)delayUpdateLocationHeaders:(NSArray *)headersInfo {
    if (headersInfo.count == 0) {
        return;
    }
    _tempLocHeaderInfos = [headersInfo copy];
    if (_isUpdateLocHeadersInQueue) {
        return;
    } else {
        _isUpdateLocHeadersInQueue = YES;
        executeInMainThreadAfter(INTERVAL_UDPATE_LOCATION_HEADERS, ^{
            [self updateLocationHeaders];
        });
    }
}

- (void)updateLocationHeaders {
    _isCaptureScrollEvent = NO;
    for (MZLLocationHeaderContainer *locHeader in _locationHeaders) {
        [locHeader removeFromParent];
    }
    [self generateLocationHeaders:_tempLocHeaderInfos];
    [self onScrollViewScroll:self.wvArticleContent.scrollView];
    _isUpdateLocHeadersInQueue = NO;
    _isCaptureScrollEvent = YES;
}

- (NSArray *)headersInfoFromData:(id)data {
    NSMutableArray *result = [NSMutableArray array];
    if ([data isKindOfClass:[NSArray class]]) {
        for (id locHeaderData in data) {
            if ([locHeaderData isKindOfClass:[NSDictionary class]]) {
                MZLLocationHeaderInfo *headerInfo = [MZLLocationHeaderInfo instanceFromDictionary:locHeaderData];
                [result addObject:headerInfo];
            }
        }
    }
    return result;
}

- (MZLLocationHeaderContainer *)locationHeaderContainer:(MZLLocationHeaderInfo *)headerInfo {
    MZLLocationHeaderContainer *result = [MZLLocationHeaderContainer headerContainer:headerInfo parentScroll:self.wvArticleContent.scrollView parentAttachView:self.wvArticleContent topBarHeight:TOP_BAR_HEIGHT];
    [result addTapGestureRecognizer:self action:@selector(onHeaderContainerClicked:)];
    return result;
}

- (void)onHeaderContainerClicked:(id)sender {
    MZLLocationHeaderView *headerView = (MZLLocationHeaderView *)[sender view];
    MZLLocationRouteInfo *locRouteInfo = [_childVwController locRouteInfoFromIndex:headerView.container.position];
    _childVwController.targetLocationRouteInfo = locRouteInfo;
    _childVwController.ignoreParentScroll = YES;
    [self showChildVwController];
    [MobClick event:@"clickArticleDetailPOI"];
    [MobClick event:@"clickArticleDetailSidebar"];
}

- (void)generateLocationHeaders:(NSArray *)locationHeadersInfo {
    _locationHeaders = [NSMutableArray array];
    NSInteger pos = 1;
    for (MZLLocationHeaderInfo *headerInfo in locationHeadersInfo) {
        MZLLocationHeaderContainer *headerContainer = [self locationHeaderContainer:headerInfo];
        headerContainer.position = pos;
        pos ++;
        [_locationHeaders addObject:headerContainer];
    }
}

- (void)scrollToLocationHeader:(MZLLocationRouteInfo *)locRouteInfo {
    if (! locRouteInfo) {
        return;
    }
    for (MZLLocationHeaderContainer *container in _locationHeaders) {
        if (container.position == locRouteInfo.index) {
            [self scrollToLocationHeaderWithHeaderInfo:container.headerInfo animated:YES];
            break;
        }
    }
}

- (void)scrollToLocationHeaderWithLocation:(MZLModelLocationBase *)location {
    if (! location) {
        return;
    }
    // find the first matched and scroll
    for (MZLLocationHeaderContainer *container in _locationHeaders) {
        if (container.headerInfo.location.identifier == location.identifier) {
            [self scrollToLocationHeaderWithHeaderInfo:container.headerInfo animated:NO];
            break;
        }
    }
}

- (void)scrollToLocationHeaderWithHeaderInfo:(MZLLocationHeaderInfo *)headerInfo animated:(BOOL)animated {
    CGPoint pointToScroll = CGPointMake(0.0, headerInfo.startY - TOP_BAR_HEIGHT);
    [self.wvArticleContent.scrollView setContentOffset:pointToScroll animated:animated];
}

- (void)scrollToTargetLocation {
    if (self.targetLocation && _locationHeaders.count > 0) {
        [self scrollToLocationHeaderWithLocation:self.targetLocation];
        self.targetLocation = nil;
    }
}

#pragma mark - web view delegate

- (void)onWebViewDidFinishLoadForFirstTime:(NSArray *)locationHeadersInfo {
    [self cancelTimer];
    // 禁用用户选择
    [self.wvArticleContent stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // 禁用长按弹出框
    [self.wvArticleContent stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    [self generateLocationHeaders:locationHeadersInfo];
    [self adjustTripsOrder:locationHeadersInfo];
    
    // 所有弹出层的信息已经得到，初始化childView
    [self initChildViewController];
    [self initNavItems];

    // 如果设置了targetLocation, 跳转到指定目的地
    [self scrollToTargetLocation];
    [self hideProgressIndicator];
    _isCaptureScrollEvent = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self cancelTimer];
    [self onWebViewLoadError];
}

- (void)onWebViewLoadError {
    [self onNetworkError];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {}

#pragma mark - share

- (void)share {
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    NSMutableString *_articleContent = [NSMutableString string];
    NSMutableString *_articleDescription = [NSMutableString string];
    [_articleContent appendFormat:@"%@%@ %@", _articleDetail.summary, @"...", _articleDetail.articleUrl];
    [_articleDescription appendFormat:@"%@%@", _articleDetail.summary, @"..."];
    NSString *imageURL = [_articleDetail.coverImageUrl imageUrl_640_360];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:_articleContent
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:imageURL]
                                                title:_articleDetail.title
                                                  url:_articleDetail.articleUrl
                                          description:_articleDescription
                                            mediaType:SSPublishContentMediaTypeNews];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:nil
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:NO
                                                        wxSessionButtonHidden:NO
                                                       wxTimelineButtonHidden:NO
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:nil
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    NSArray *shareList = [NSArray array];
    if ([WXApi isWXAppInstalled]) {
        NSArray *wxShareList = [ShareSDK customShareListWithType:
                                SHARE_TYPE_NUMBER(ShareTypeWeixiFav),
                                SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                                SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline), nil];
        shareList = [shareList arrayByAddingObjectsFromArray:wxShareList];
    }
    if ([WeiboSDK isWeiboAppInstalled]) {
        // 新浪微博分享内容需要定制
        id<ISSShareActionSheetItem> item = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
                                                                              icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                                                                      clickHandler:^{
                                                                          NSString *newContent = [NSString stringWithFormat:@"我在#美周六app#发现了：%@ %@，@美周六", [publishContent title], [publishContent url] ];
                                                                          [publishContent setContent:newContent];
                                                                          [ShareSDK clientShareContent:publishContent
                                                                                                  type:ShareTypeSinaWeibo
                                                                                         statusBarTips:YES
                                                                                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                                    [self onShareResultWithType:type state:state statusInfo:statusInfo error:error end:end];
                                                                                                }];
                                                                      }];
        NSArray *weiboShareList = [ShareSDK customShareListWithType:item, nil];
        shareList = [shareList arrayByAddingObjectsFromArray:weiboShareList];
    }
    if ([QQApi isQQInstalled]) {
        NSArray *qqShareList = [ShareSDK customShareListWithType:
                                SHARE_TYPE_NUMBER(ShareTypeQQ),
                                SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                                nil];
        shareList = [shareList arrayByAddingObjectsFromArray:qqShareList];
    }
    if (shareList.count == 0) {
        return;
    }
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                [self onShareResultWithType:type state:state statusInfo:statusInfo error:error end:end];
                            }];
    
    
    [MobClick event:@"clickArticleDetailShare"];
}

- (void)onShareResultWithType:(ShareType)type state:(SSResponseState)state statusInfo:(id<ISSPlatformShareInfo>)statusInfo error:(id<ICMErrorInfo>)error end:(BOOL)end {
    if (state == SSResponseStateFail) {
        // NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
        NSString *errorDesp = [error errorDescription];
        NSInteger errorCode = [error errorCode];
        if (isEmptyString(errorDesp) || errorCode == 0) {
            return;
        }
        [UIAlertView showAlertMessage:[NSString stringWithFormat:@"分享失败：%@（错误码:%@）", errorDesp, @(errorCode)]];
    }
}

#pragma mark - stats

- (NSString *)statsID {
    return @"文章详情页";
}

#pragma mark - misc

- (NSInteger)totalDestCountFromTrips {
    NSInteger result = 0;
    for (MZLModelRouteInfo *routeInfo in _articleDetail.trips) {
        result += routeInfo.destinations.count;
    }
    return result;
}

/** 从Service得到的trip的单天行程目的地顺序是乱的，调整成跟网页显示一致的顺序 */
- (void)adjustTripsOrder:(NSArray *)locationHeadersInfo {
    if (locationHeadersInfo.count == 0 || _articleDetail.trips.count == 0) {
        NSLog(@"Article Detail - failed to adjust trip order due to no data");
    }
    NSMutableArray *sortedDestinationsPerDay = [NSMutableArray array];
    NSInteger tripCount = _articleDetail.trips.count;
    NSInteger tripIndex = 0;
    MZLModelRouteInfo *trip;
    for (MZLLocationHeaderInfo *headerInfo in locationHeadersInfo) {
        BOOL findFlag = false;
        while (! findFlag && tripIndex < tripCount) {
            trip = _articleDetail.trips[tripIndex];
            for (MZLModelLocationBase *loc in trip.destinations) {
                if (loc.identifier == headerInfo.location.identifier) {
                    [sortedDestinationsPerDay addObject:loc];
                    findFlag = YES;
                    break;
                }
            }
            if (! findFlag) {  // 当前trip没有相关信息，跳到下一个，并设置当前trip的destinations
                trip.destinations = [sortedDestinationsPerDay copy];
                [sortedDestinationsPerDay removeAllObjects];
                tripIndex ++;
            }
        }
        if (tripIndex >= tripCount) { // 数据错误，网页的数据后台没有对应的目的地
            break;
        }
    }
    if (sortedDestinationsPerDay.count > 0) {
        trip = _articleDetail.trips[tripIndex];
        trip.destinations = [sortedDestinationsPerDay copy];
    }
}

#pragma mark - iVersionDelegate methods

- (BOOL)iRateShouldPromptForRating
{
	//don't show prompt, just open app store
	//[[iRate sharedInstance] openRatingsPageInAppStore];
	return [iRate sharedInstance].shouldPromptForRating;
}

#pragma mark - timer for loading web content from the URL

- (void)initTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:MZL_DEFAULT_TIMEOUT target:self selector:@selector(onTimeout:) userInfo:nil repeats:NO];
}

- (void)onTimeout:(NSTimer *)timer {
    [self onWebViewLoadError];
}

- (void)cancelTimer {
    [_timer invalidate];
}

#pragma mark - adView related

- (void)dismissAdView:(NSTimer *)timer{
    [self.wvAdVContent setVisible:NO];
}

- (BOOL)shouldShowAdView
{
    return ! isEmptyString([MZLSharedData youmengAdUrl]);
//    //如果url是否为空
//    if (isEmptyString([MZLSharedData youmengAdUrl])) {
//        return NO;
//    }
//    //check 广告已经显示时间是否超过预设的时间长度
//    else if ([[NSDate date] timeIntervalSinceDate:[self adViewShowDate]] > MZL_DEFAULT_ADVIEW_VISABLE_DAYS * SECONDS_IN_A_DAY ){
//        return NO;
//    }
//    //让我们显示广告吧!
//    return YES;
}

////设置广告开始显示时间
//- (NSDate *) adViewShowDate{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    [comps setYear:2014];
//    [comps setMonth:7];
//    [comps setDay:16];
//    [comps setHour:0];
//    [comps setMinute:0];
//    [comps setSecond:0];
//    NSDate *date = [calendar dateFromComponents:comps];
//    return date;
//}
#pragma mark - override parent

- (void)mzl_pushViewController:(UIViewController *)vc {
    if ([self isChildViewVisible]) {
        [_childVwController hideWithAnimation:^{
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
