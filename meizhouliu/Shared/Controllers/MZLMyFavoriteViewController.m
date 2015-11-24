//
//  MZLMyFavoriteViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-17.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLMyFavoriteViewController.h"
#import "UIImageView+MZLNetwork.h"
#import "UITableView+MZLAdditions.h"
#import "MZLSharedData.h"

#import "MZLServices.h"
#import "MZLModelLocation.h"
#import "MZLPagingSvcParam.h"
#import "MZLModelUserLocationPref.h"
#import "MZLModelUserFavoredArticle.h"
#import "MZLArticleItemTableViewCell.h"
#import "MZLMyNormalTopBar.h"
#import "MZLMyAuthorTopBar.h"
#import "MZLAppUser.h"
#import "MZLModelUser.h"
#import "MobClick.h"
#import "MZLNotificationItemTableViewCell.h"
#import "MZLModelNotice.h"
#import "MZLAppNotices.h"
#import <IBMessageCenter.h>
#import "MZLShortArticleCell.h"

#import "MZLLoginViewController.h"
#import "MZLTabBarViewController.h"

#import "UIViewController+MZLShortArticle.h"
#import "UIView+MZLAdditions.h"

#define STATUS_UNKNOWN -1
#define STATUS_NOT_LOGINED 0
#define STATUS_LOGINED 1


//#define SEGUE_TOLOGIN @"toLogin"

#define SEGUE_TOLOGIN @"toLog"
#define SEGUE_TOSETTING @"toSetting"

@interface MZLMyFavoriteViewController () <MZLMyTopBarDelegate> {
    MZLMyNormalTopBar *_headView;
    NSInteger segmentedAtindex;
    NSInteger _loginStatus;
    BOOL _refreshFlag;
}

@end

@implementation MZLMyFavoriteViewController

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
    _loginStatus = STATUS_UNKNOWN;
    [self initUI];
    // 需要根据login status生成header bar，否则有通知消息时无法跳转通知tab
    [self checkLoginStatus];
    [self registerNotifications];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([MZLSharedData hasApsInfo]) {
        [self launchToNoticeDetail];
    } else {
        [self checkLoginStatus];
        if (_refreshFlag) {
            _refreshFlag = NO;
            [self refreshViewData];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [IBMessageCenter removeMessageListenersForTarget:self];
}

- (void)initUI {
    self.view.backgroundColor = MZL_BG_COLOR();
    
    _tv = self.tvMy;
    _tv.backgroundColor = [UIColor clearColor];
    [self adjustTableViewBottomInset:self.tabBarController.tabBar.height scrollIndicatorBottomInset:self.tabBarController.tabBar.height];
    [_tv removeUnnecessarySeparators];
    [_tv setSeparatorColor:MZL_SEPARATORS_BG_COLOR()];
    
//    [self onLoginStatusChanged];
}

- (void)updateHeadBarUI {
    [_headView removeFromSuperview];
    UIWindow *window = globalWindow();
    //初始化顶部TAB BAR
    if (_loginStatus == STATUS_LOGINED) {
        _headView = [MZLMyAuthorTopBar tabBarInstance:window.bounds.size];
    } else {
        _headView = [MZLMyNormalTopBar tabBarInstance:window.bounds.size];
    }
    _headView.delegate = self;
    [self.vwTopBar addSubview:_headView];
}

#pragma mark - login status

- (void)checkLoginStatus {
    NSInteger newStatus = [MZLSharedData isAppUserLogined] ? STATUS_LOGINED : STATUS_NOT_LOGINED;
    if (newStatus != _loginStatus) {
        _loginStatus = newStatus;
        [self onLoginStatusChanged];
    }
}

- (void)onLoginStatusChanged {
    [self updateHeadBarUI];
    if (_loginStatus == STATUS_LOGINED) {
        [self toTabWithIndex:MZL_MY_ARTICLE_INDEX];
    } else {
        [self toTabWithIndex:MZL_MY_WANT_INDEX];
    }
    self.btnLoginSetting.target = self;
    if (_loginStatus == STATUS_LOGINED) {
        [self.btnLoginSetting setImage:[UIImage imageNamed:@"Setting"]];
        self.btnLoginSetting.action = @selector(toSettings);
    } else {
        [self.btnLoginSetting setImage:[UIImage imageNamed:@"Login"]];
        self.btnLoginSetting.action = @selector(toLogin);
    }
}

-  (void)refreshAppMessageCount {
    [((MZLMyNormalTopBar *)_headView) updateUnreadCount];
}

#pragma mark - notifications and listeners

- (void)registerNotifications {
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_APP_MESSAGE_UPDATED target:self action:@selector(onAppMessagesUpdated)];
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_USER_FAVOR_ARTICLE_UPDATED target:self action:@selector(onUserFavorArticleStatusModified)];
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_USER_FAVOR_LOCATION_UPDATED target:self action:@selector(onUserFavorLocationStatusModified)];
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_USER_UP_ARTICLE_UPDATED target:self action:@selector(onUserUpArticleStatusModified)];
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_MY_TO_ARTICLE target:self action:@selector(toMyArticle)];
}

- (void)toMyArticle {
    [self toTabWithIndex:MZL_MY_ARTICLE_INDEX];
}

- (void)onAppMessagesUpdated {
    [self refreshAppMessageCount];
}

- (void)onUserFavorArticleStatusModified {
    [self setRefreshFlagOnSegmentedIndex:MZL_MY_FAVOR_INDEX];
}

- (void)onUserFavorLocationStatusModified {
    [self setRefreshFlagOnSegmentedIndex:MZL_MY_WANT_INDEX];
}

- (void)onUserUpArticleStatusModified {
    [self setRefreshFlagOnSegmentedIndex:MZL_MY_ARTICLE_INDEX];
}

- (void)setRefreshFlagOnSegmentedIndex:(NSInteger)segmentedIndex {
    if (segmentedAtindex == segmentedIndex) {
        if (! [self isVisible]) {
            _refreshFlag = YES;
        }
    }
}

#pragma mark - Navigation
/*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)toLogin {
    [self performSegueWithIdentifier:SEGUE_TOLOGIN sender:nil];
}   

- (void)toSettings {
    [self performSegueWithIdentifier:SEGUE_TOSETTING sender:nil];
}

#pragma mark - override

- (NSString *)statsID {
    return @"我的收藏页面";
}

- (void)refreshOnDelete {
    [self refreshViewData];
}

- (void)mzl_onWillBecomeTabVisibleController {
    if (shouldPopupLogin()) {
        MZLTabBarViewController *tabVC = (MZLTabBarViewController *)self.tabBarController;
        [tabVC showMzlTabBar:NO animatedFlag:NO];
        [self popupLoginFrom:MZLLoginPopupFromMy executionBlockWhenDismissed:^{
            
        }];
    } else {
        [self refreshWhenViewIsVisible];
    }
}

- (void)mzl_viewControllerBecomeActiveFromBackground {
    if (segmentedAtindex == MZL_MY_NOTIFICATION_INDEX) {
        [self refreshViewData];
    }
}

- (NSInteger)pageFetchCount {
    if (segmentedAtindex == MZL_MY_ARTICLE_INDEX) {
        return MZL_SHORT_ARTICLE_PAGE_FETCH_COUNT;
    }
    return [super pageFetchCount];
}

- (void)mzl_removeShortArticleAtIndexPath:(NSIndexPath *)indexPath {
    [self deleteModelOnIndexPath:indexPath selector:@selector(removeShortArticle:succBlock:errorBlock:) params:@[_models[indexPath.row]]];
}

#pragma mark - protected table footer

- (NSArray *)noRecordTexts {
    if (segmentedAtindex == MZL_MY_FAVOR_INDEX) {
        return @[@"暂无收藏"];
    } else if (segmentedAtindex == MZL_MY_WANT_INDEX) {
        return @[@"暂无想去"];
    } else if (segmentedAtindex == MZL_MY_NOTIFICATION_INDEX) {
        return @[@"暂无消息"];
    } else if (segmentedAtindex == MZL_MY_ARTICLE_INDEX){
        return @[@"还没发布玩法"];
    }
    return [super noRecordTexts];
}

- (UIImageView *)noRecordImageView:(UIView *)superView {
    CGSize size = CGSizeMake(24, 24);
    if (segmentedAtindex == MZL_MY_FAVOR_INDEX) {
        return [self imageViewWithImageNamed:@"NoFavor" size:size superView:superView];
    } else if (segmentedAtindex == MZL_MY_WANT_INDEX) {
        return [self imageViewWithImageNamed:@"NoWant" size:size superView:superView];
    } else if (segmentedAtindex == MZL_MY_NOTIFICATION_INDEX) {
        return [self imageViewWithImageNamed:@"Notice" size:size superView:superView];
    }
    return [super noRecordImageView:superView];
}

- (CGFloat)footerSpacingViewHeight {
    return 10;
}

- (UIView *)footerSpacingView {
    if (segmentedAtindex == MZL_MY_FAVOR_INDEX) {
        return [super footerSpacingView];
    } else {
        UIView *view = [super footerSpacingView];
        [view createTopSepView];
        return view;
    }
}

#pragma mark - load & load more

- (void)refreshViewData {
    MZLPagingSvcParam *param = [MZLPagingSvcParam pagingSvcParamWithPageIndex:1 fetchCount:[self pageFetchCount]];
    if (segmentedAtindex == MZL_MY_FAVOR_INDEX) {
        [self loadModels:@selector(favoredArticlesWithPagingParam:succBlock:errorBlock:) params:@[param]];
    }
    else if (segmentedAtindex == MZL_MY_WANT_INDEX) {
        [self loadModels:@selector(favoredLocationsWithPagingParam:succBlock:errorBlock:) params:@[param]];
    }
    else if (segmentedAtindex == MZL_MY_ARTICLE_INDEX) {
        [self loadModels:@selector(authorShortArticleListWithPagingParam:succBlock:errorBlock:) params:@[param]];
    }
    else {
        [self loadModels:@selector(noticeFromLocalWithsuccBlock:errorBlock:) params:nil];
    }
}

- (void)refreshWhenViewIsVisible {
    if ([self isVisible]) {
        [self refreshViewData];
    } else {
        _refreshFlag = YES;
    }
}

- (BOOL)_canLoadMore {
    // 消息暂不分页
    if (segmentedAtindex == MZL_MY_NOTIFICATION_INDEX) {
        return NO;
    }
    return YES;
}

- (void)_loadMore {
    MZLPagingSvcParam *param = [self pagingParamFromModels];
    if (segmentedAtindex == MZL_MY_ARTICLE_INDEX) {
        [self invokeLoadMoreService:@selector(authorShortArticleListWithPagingParam:succBlock:errorBlock:) params:@[param]];
    } else if (segmentedAtindex == MZL_MY_FAVOR_INDEX) {
        [self invokeLoadMoreService:@selector(favoredArticlesWithPagingParam:succBlock:errorBlock:) params:@[param]];

    } else if (segmentedAtindex == MZL_MY_WANT_INDEX) {
        [self invokeLoadMoreService:@selector(favoredLocationsWithPagingParam:succBlock:errorBlock:) params:@[param]];
        
    }else {
        //消息不分页
    }
}

#pragma mark - table view data source

- (MZLNotificationItemTableViewCell *)noticeItemCellAtIndexPath:(NSIndexPath *)indexPath {
    return [self noticeItemCellAtIndexPath:indexPath notice:[self modelObjectForIndexPath:indexPath]];
}

- (MZLNotificationItemTableViewCell *)noticeItemCellAtIndexPath:(NSIndexPath *)indexPath notice:(MZLModelNotice *)notice {
    MZLNotificationItemTableViewCell *cell = [_tv dequeueReusableNotificationItemCell];
    if (!cell.isVisted) {
        [cell updateOnFirstVisit];
    }
    [cell updateContentFromNotice:notice];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_models.count > 0) {
        if (segmentedAtindex == MZL_MY_WANT_INDEX) {
            MZLModelLocation *location =  ((MZLModelUserLocationPref *)_models[indexPath.row]).location;
            MZLLocationItemCell *cell = [self locationItemCellAtIndexPath:indexPath location:location];
            return cell;
        } else if (segmentedAtindex == MZL_MY_NOTIFICATION_INDEX){
            MZLModelNotice *notice = (MZLModelNotice *)_models[indexPath.row];
            MZLNotificationItemTableViewCell *cell = [self noticeItemCellAtIndexPath:indexPath notice:notice];
            return cell;
        } else if (segmentedAtindex == MZL_MY_ARTICLE_INDEX) {
            MZLShortArticleCell *cell = [MZLShortArticleCell cellWithTableview:tableView type:MZLShortArticleCellTypeMy model:_models[indexPath.row]];
//            cell.ownerController = self;
            return cell;
        } else {
            MZLModelArticle  *article = ((MZLModelUserFavoredArticle *)_models[indexPath.row]).article;
            MZLArticleItemTableViewCell *cell = [self articleItemCellAtIndexPath:indexPath article:article hideAuthorFlag:(segmentedAtindex == MZL_MY_ARTICLE_INDEX)];
            return cell;
        }
    }
    return nil;
}


#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (segmentedAtindex == MZL_MY_FAVOR_INDEX) {
        [MobClick event:@"clickMyFavoritePlayDelete"];
        MZLModelUserFavoredArticle *favoredArticle = ((MZLModelUserFavoredArticle *)_models[indexPath.row]);
        [self deleteModelOnIndexPath:indexPath selector:@selector(removeFavoredArticle:succBlock:errorBlock:) params:@[favoredArticle]];
    } else if(segmentedAtindex == MZL_MY_WANT_INDEX){
        [MobClick event:@"clickMyFavoriteLocationDelete"];
        MZLModelUserLocationPref *favoredLocation = ((MZLModelUserLocationPref *)_models[indexPath.row]);
        [self deleteModelOnIndexPath:indexPath selector:@selector(removeFavoredLocation:succBlock:errorBlock:) params:@[favoredLocation]];
    } else {
        MZLModelNotice *messageToDelete = _models[indexPath.row];
        [self deleteModelOnIndexPath:indexPath selector:@selector(removeNoticeFromLocal:succBlock:errorBlock:) params:@[messageToDelete]];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (segmentedAtindex == MZL_MY_ARTICLE_INDEX) {
        return NO;
    }
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (segmentedAtindex == MZL_MY_WANT_INDEX) {
        return MZL_LOCATIONCELL_HEIGHT;
    } else if (segmentedAtindex == MZL_MY_NOTIFICATION_INDEX){
        return MZL_NOTIFICATIONCELL_HEIGHT;
    } else if (segmentedAtindex == MZL_MY_ARTICLE_INDEX) {
        return [MZLShortArticleCell heightForTableView:tableView withType:MZLShortArticleCellTypeMy withModel:_models[indexPath.row]];
//        return [MZLShortArticleCell heightFromType:MZLShortArticleCellTypeMy model:_models[indexPath.row]];
    } else {
        return MZL_ARTICLECELL_HEIGHT;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self navigate:indexPath];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self navigate:indexPath];
}

- (void)navigate:(NSIndexPath *)indexPath {
    if (segmentedAtindex == MZL_MY_WANT_INDEX) {
        MZLModelLocation *location = ((MZLModelUserLocationPref *)_models[indexPath.row]).location;
        [self performSegueWithIdentifier:MZL_SEGUE_TOLOCATIONDETAIL sender:location];
    } if (segmentedAtindex == MZL_MY_NOTIFICATION_INDEX) {
        MZLModelNotice *notice = ((MZLModelNotice *)_models[indexPath.row]);
        MZLNotificationItemTableViewCell *cell = (MZLNotificationItemTableViewCell *)[_tv cellForRowAtIndexPath:indexPath];
        [cell updateOnNoticeRead];
        [self performSegueWithIdentifier:MZL_SEGUE_NOTICEDETAIL sender:notice];
    }
}

#pragma mark - remote notification related

- (void)launchToNoticeDetail {
    BOOL hasNotice = ! isEmptyString([[[MZLSharedData apsInfo] valueForKey:@"notice"] valueForKey:@"id"]);
    
    //如果推送有消息内容时，切换到“消息”的TAB
    if (hasNotice) {
        [self toTabWithIndex:MZL_MY_NOTIFICATION_INDEX];
        MZLModelNotice *notice = [[MZLModelNotice alloc] init];
        notice.identifier = [[[[MZLSharedData apsInfo] valueForKey:@"notice"] valueForKey:@"id"] intValue];
        [self performSegueWithIdentifier:MZL_SEGUE_NOTICEDETAIL sender:notice];
        [MZLSharedData setApnsInfo:nil];
    }
}

#pragma mark - MZLMyTopBarDelegate

- (void)onMyTopBarTabSelected:(NSInteger)tabIndex {
    [self toTabWithIndex:tabIndex];
}

#pragma mark - misc

- (void)toTabWithIndex:(NSInteger)tabIndex {
    segmentedAtindex = tabIndex;
    [_headView onTabSelected:tabIndex];
    UIEdgeInsets insets = _tv.contentInset;
    if (tabIndex == MZL_MY_FAVOR_INDEX) {
        insets.top = 5;
        _tv.contentInset = insets;
        [_tv setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    } else {
        insets.top = 0;
        _tv.contentInset = insets;
        _tv.separatorColor = @"D8D8D8".co_toHexColor;
        [_tv setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    }
    [self refreshWhenViewIsVisible];
}

- (NSInteger)loginedUserId {
    return [MZLSharedData appUser].user.identifier;
}

@end
