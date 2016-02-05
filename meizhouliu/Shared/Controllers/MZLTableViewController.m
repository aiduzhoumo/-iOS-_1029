//
//  MZLTableViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-16.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLTableViewController.h"
#import "MZLServices.h"
#import "MZLPagingSvcParam.h"
#import "MZLModelObject.h"
#import "RestKit/RestKit.h"
#import "NSInvocation+COAdditions.h"
#import "UIViewController+ScrollToRefresh.h"
#import "MZLSystemArticleListViewController.h"
#import <Masonry/Masonry.h>

#import <objc/runtime.h>
#import <objc/message.h>

@interface MZLTableViewController () {
    NSInteger _scrollState;
    UIView *_noRecordView;
}

@end

@implementation MZLTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _hasMore = YES;
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
    if (_tv) {
        _tv.delegate = nil;
    }
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

#pragma mark - table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (! _models) {
        return 0;
    }
    if (_isMultiSections) {
        return _models.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getModelsForSection:section].count;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - scrollToRefresh protected

- (NSInteger)scrollState {
    return _scrollState;
}

- (void)setScrollState:(NSInteger)scrollState {
    _scrollState = scrollState;
}

- (BOOL)isCaptureScrollEvent {
    return [self canLoadMore];
}

//#pragma mark - event for scroll view delegate
//
//- (void)onScrollScrollingOnBottom {
//    [self createFooterPullToRefreshView];
//}
//
//- (void)onScrollRefreshOnReleaseOnBottom {
//    [self createFooterRefreshOnReleaseView];
//}
//
//- (void)onScrollRefreshOnBottom {
//    [self loadMore];
//}
//
//- (void)onScrollStateReset {
//    if ([self canLoadMore]) {
//        [self createFooterPullToRefreshView];
//    }
//}
//
//- (void)onScrollToLoadMoreData {
//    NSArray *indexPathForVisibleRows = [_tv indexPathsForVisibleRows];
//    if ([self canLoadMore]) {
//        [self loadMore];
//    }
//}

#pragma mark - scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (! [self isCaptureScrollEvent]) {
        return;
    }
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenEndY = contentOffsetY + screenHeight;
    NSIndexPath *indexPath = [_tv indexPathForRowAtPoint:CGPointMake(0, screenEndY)];
    
    NSInteger index = indexPath.row;
    /** note that _model.count is NSUInteger */
    if ((index + 1) >= ((NSInteger)_models.count - [self pageFetchCount] / 2)) {
        [self loadMore];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

#pragma mark - protected for table view cell

- (NSArray *)getModelsForSection:(NSInteger)section {
    if (! _isMultiSections) {
        return _models;
    } else {
        return _models[section];
    }
}

- (BOOL)isLastRow:(NSIndexPath *)indexPath {
    NSInteger sectionCount = [self numberOfSectionsInTableView:_tv];
    NSArray *modelsForLastSection = [self getModelsForSection:sectionCount - 1];
    return (indexPath.section == sectionCount - 1) && (indexPath.row == modelsForLastSection.count - 1);
}

- (id)modelObjectForIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionModels = [self getModelsForSection:indexPath.section];
    return sectionModels[indexPath.row];
}

#pragma mark - protected for ArticleItemCell

- (MZLArticleItemTableViewCell *)articleItemCellAtIndexPath:(NSIndexPath *)indexPath {
    return [self articleItemCellAtIndexPath:indexPath article:nil hideAuthorFlag:NO];
}

- (MZLArticleItemTableViewCell *)articleItemCellAtIndexPath:(NSIndexPath *)indexPath article:(MZLModelArticle *)article {
    return [self articleItemCellAtIndexPath:indexPath article:article hideAuthorFlag:NO];
}

- (MZLArticleItemTableViewCell *)articleItemCellAtIndexPath:(NSIndexPath *)indexPath article:(MZLModelArticle *)article hideAuthorFlag:(BOOL)hideAuthorFlag {
    MZLModelArticle *articleParam = article ? article : [self modelObjectForIndexPath:indexPath];
    MZLArticleItemTableViewCell *cell = [_tv dequeueReusableArticleItemCell];
    if (! cell.isVisted) {
        [cell updateOnFirstVisit:self];
    }
    cell.vwAuthor.hidden = hideAuthorFlag;
    // 仅当为精选文章列表且没有filter时不需要显示推精标识
    BOOL showFeaturedFlag = [self shouldShowFeaturedFlagForArticleCell];
    // 每次更新属性，否则由于cell复用，同一个cell会跳到同一篇文章
    [cell updateContentFromArticle:articleParam showFeaturedFlag:showFeaturedFlag];
    if ([self isLastRow:indexPath]) { // 最后一行，把bottom margin去掉
        cell.bottomMargin.constant = 0;
    } else {
        cell.bottomMargin.constant = ARTICLE_CELL_DEFAULT_BOTTOM_MARGIN;
    }
    return cell;
}

- (CGFloat)articleItemCellHeight:(NSIndexPath *)indexPath {
    CGFloat height = MZL_ARTICLECELL_HEIGHT;
    if ([self isLastRow:indexPath]) {
        height = height - ARTICLE_CELL_DEFAULT_BOTTOM_MARGIN;
    }
    return height;
}
                             
- (BOOL)shouldShowFeaturedFlagForArticleCell {
    return [self hasFilters] || ! [self isMemberOfClass:[MZLSystemArticleListViewController class]];
}

#pragma mark - protected for LocationItemCell

- (MZLLocationItemCell *)locationItemCellAtIndexPath:(NSIndexPath *)indexPath {
    return [self locationItemCellAtIndexPath:indexPath location:[self modelObjectForIndexPath:indexPath]];
}

- (MZLLocationItemCell *)locationItemCellAtIndexPath:(NSIndexPath *)indexPath location:(MZLModelLocationBase *)location {
    MZLLocationItemCell *cell = [_tv dequeueReusableLocationItemCell];
    if (! cell.isVisted) {
        [cell updateOnFirstVisit];
    }
    [cell updateContentFromLocation:location];
    return cell;
}

#pragma mark - protected for RelatedLocationItemCell

- (MZLLocationItemCell *)relatedLocationItemCellAtIndexPath:(NSIndexPath *)indexPath {
    return [self relatedLocationItemCellAtIndexPath:indexPath location:[self modelObjectForIndexPath:indexPath]];
}

- (MZLLocationItemCell *)relatedLocationItemCellAtIndexPath:(NSIndexPath *)indexPath location:(MZLModelLocationBase *)location {
    MZLLocationItemCell *cell = [_tv dequeueReusableLocationItemCell];
    if (! cell.isVisted) {
        [cell updateOnFirstVisit];
    }
    [cell updateContentFromRelatedLocation:location];
    return cell;
}

//#pragma mark - protected for noticeItemCell
//- (MZLNotificationItemTableViewCell *)noticeItemCellAtIndexPath:(NSIndexPath *)indexPath {
//    return [self noticeItemCellAtIndexPath:indexPath notice:[self modelObjectForIndexPath:indexPath]];
//}
//
//- (MZLNotificationItemTableViewCell *)noticeItemCellAtIndexPath:(NSIndexPath *)indexPath notice:(MZLModelNotice *)notice {
//    MZLNotificationItemTableViewCell *cell = [_tv dequeueReusableNotificationItemCell];
//    if (!cell.isVisted) {
//        [cell updateOnFirstVisit];
//    }
//    [cell updateContentFromNotice:notice];
//    return cell;
//}

#pragma mark - protected reset methods

- (void)adjustTableViewInsets {
    [self adjustTableViewBottomInset:0.0 scrollIndicatorBottomInset:0.0];
}

- (void)adjustTableViewBottomInset:(CGFloat)tvBottom scrollIndicatorBottomInset:(CGFloat)scrollBottomInset {
    UIEdgeInsets tvInsets = _tv.contentInset;
    tvInsets.bottom = tvBottom;
    _tv.contentInset = tvInsets;
    UIEdgeInsets tvSepInsets = _tv.scrollIndicatorInsets;
    tvSepInsets.bottom = scrollBottomInset;
    _tv.scrollIndicatorInsets = tvSepInsets;
}

- (void)reset {
    _models = nil;
    if (_noRecordView) {
        [_noRecordView removeFromSuperview];
        _noRecordView = nil;
    }
    [self resetOperationIfRunning];
    [self resetFlags];
    [self resetTableViews];
}

- (void)resetOperationIfRunning {
    void (^resetOperIfUnfinished)(NSOperation *) = ^ (NSOperation *operation) {
        if (operation) {
            if (! [operation isFinished]) {
                [operation cancel];
            }
        }
    };
    resetOperIfUnfinished(_loadOp);
    resetOperIfUnfinished(_loadMoreOp);
    _loadOp = nil;
    _loadMoreOp = nil;
}

- (void)resetFlags {
    _loading = NO;
    _loadingMore = NO;
    _hasMore = YES;
    _isMultiSections = NO;
//    [self resetScrollState];
}

- (void)resetTableViews {
    _tv.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_tv reloadData];
}

#pragma mark - protected for load

- (void)invokeService:(SEL)selector params:(NSArray *)parameters {
    __weak MZLTableViewController *weakSelf = self;
    MZL_SVC_SUCC_BLOCK succBlock = ^(NSArray *models) {
        [weakSelf onLoadSuccBlock:models];
    };
    MZL_SVC_ERR_BLOCK errorBlock = ^(NSError *error) {
        [weakSelf onLoadErrorBlock:error];
    };
    _loadOp = [self invokeService:selector params:parameters succBlock:succBlock errorBlock:errorBlock];
}

- (void)beforeLoadModels {
    [self reset];
    [self showNetworkProgressIndicator];
    _loading = YES;
}

- (void)loadModels {
    [self beforeLoadModels];
    [self _loadModels];
}

- (void)loadModelsWhenViewIsVisible {
    // 暂由子类提供实现
}

- (void)loadModels:(SEL)selector params:(NSArray *)parameters {
    [self beforeLoadModels];
    [self invokeService:selector params:parameters];
}

// override point, to actually invoke service to load models
- (void)_loadModels {}

- (void)onLoadSuccBlock:(NSArray *)modelsFromSvc {
//    [self resetRefreshTime];
//    [self hideProgressIndicator];
    _loading = NO;
    [self handleModelsOnLoad:modelsFromSvc];
    [self createTipViewOnLoadSucc];
    [self _onLoadSuccBlock:modelsFromSvc];
    [self handModelsToOtherService:modelsFromSvc];
}

- (void)handModelsToOtherService:(NSArray *)modelsFromSvc {
    [self hideProgressIndicator];
    [_tv reloadData];
}
- (NSMutableArray *)mapModelsOnLoad:(NSArray *)modelsFromSvc {
    return [NSMutableArray arrayWithArray:modelsFromSvc];
}

- (void)handleModelsOnLoad:(NSArray *)modelsFromSvc {
    _isMultiSections = NO;
    _models = [self mapModelsOnLoad:modelsFromSvc];
    _hasMore = (_models.count >= [self pageFetchCount]);
}

// override point
- (void)_onLoadSuccBlock:(NSArray *)modelsFromSvc {}

- (BOOL)_onLoadErrorBlock:(NSError *)error {
    return YES;
}

- (void)onLoadErrorBlock:(NSError *)error {
    _loading = NO;
    if ([self _onLoadErrorBlock:error]) {
        [self onNetworkError];
    }
}

- (void)createTipViewOnLoadSucc {
    if (_models.count == 0) {
        [self createNoRecordView];
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

#pragma mark - protected for load more

- (MZLPagingSvcParam *)pagingParamFromModels {
    MZLPagingSvcParam *pagingParam = [[MZLPagingSvcParam alloc] init];
    MZLModelObject *lastModelObject = [[MZLModelObject alloc] init];
    if (_models.count > 0) {
         lastModelObject = _models[_models.count - 1];
    }
    pagingParam.lastId = lastModelObject.identifier;
    pagingParam.fetchCount = [self pageFetchCount];
    pagingParam.pageIndex = _models.count / pagingParam.fetchCount + 1;
    return pagingParam;
}

- (BOOL)canLoadMore {
    if (_hasMore && ! _loadingMore && _models.count > 0) {
        return [self _canLoadMore];
    }
    return NO;
}

/** override point */
- (BOOL)_canLoadMore {
    return NO;
}

- (void)loadMore {
    _loadingMore = YES;
    [self createFooterRefreshView];
    [self _loadMore];
}

/** override point */
- (void)_loadMore {
}

- (void)invokeLoadMoreService:(SEL)selector params:(NSArray *)parameters {
    __weak MZLTableViewController *weakSelf = self;
    MZL_SVC_SUCC_BLOCK succBlock = ^(NSArray *models) {
        [weakSelf onLoadMoreSuccBlock:models];
    };
    MZL_SVC_ERR_BLOCK errorBlock = ^(NSError *error) {
        [weakSelf onLoadMoreErrorBlock:error];
    };
    _loadMoreOp = [self invokeService:selector params:parameters succBlock:succBlock errorBlock:errorBlock];
}

- (void)onLoadMoreFinished {
    _loadingMore = NO;
    _loadMoreOp = nil;
//    [self resetScrollState];
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

- (void)onLoadMoreSuccBlock:(NSArray *)modelsFromSvc {
    [self onLoadMoreFinished];
    [self handleModelsOnLoadMore:modelsFromSvc];
    [self createTipViewOnLoadMoreSucc];
    [self _onLoadMoreSuccBlock:modelsFromSvc];
    [_tv reloadData];
}

- (NSArray *)mapModelsOnLoadMore:(NSArray *)modelsFromSvc {
    return modelsFromSvc;
}

- (NSArray *)handleModelsOnLoadMore:(NSArray *)modelsFromSvc {
    NSArray *mappedModels = [self mapModelsOnLoadMore:modelsFromSvc];
    if (mappedModels.count > 0) {
        [_models addObjectsFromArray:mappedModels];
    }
    _hasMore = mappedModels.count >= [self pageFetchCount];
    return mappedModels;
}

/** override point */
- (void)_onLoadMoreSuccBlock:(NSArray *)mappedModels {
}

- (void)onLoadMoreErrorBlock:(NSError *)error {
    [self onLoadMoreFinished];
    [self createFooterPullToRefreshView];
    [UIAlertView alertOnNetworkError];
}

#pragma mark - protected no record view

#define NO_RECORD_VIEW_V_SPACING 3
#define NO_RECORD_VIEW_DEFAULT_IMAGE_W 36
#define NO_RECORD_VIEW_DEFAULT_IMAGE_H 36


- (void)createNoRecordView {
    // 先去除table footer view
    [_tv removeUnnecessarySeparators];
    [self noRecordView];
}

- (UIView *)noRecordViewSuperView {
    return _tv.superview;
}

- (UIView *)noAttentionRecordView {
    UIView *noAttentionView = [[UIView alloc] init];
    
    UIView *superView = [self noRecordViewSuperView];
    if (_tv.superview == superView) {
        [superView insertSubview:noAttentionView aboveSubview:_tv];
    }else {
        [superView insertSubview:noAttentionView atIndex:0];
    }
    _noRecordView = noAttentionView;
    
    UIView *imageView = [self imageViewWithImageNamed:@"attention_sad" size:CGSizeMake(85, 85) superView:noAttentionView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noAttentionView).offset(-84);
        make.centerX.mas_equalTo(noAttentionView);
        
    }];
    
    UIView *labelView = [self noAttentionRecordLabelView:noAttentionView];
    [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).offset(12);
        make.left.right.mas_equalTo(noAttentionView);
    }];
    //这里还要加一个按钮，进入推荐达人列表
    UIView *lookForDaRen = [self imageViewWithImageNamed:@"lookforTuiJianDaren" size:CGSizeMake(114, 30) superView:superView];
    [lookForDaRen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labelView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(noAttentionView);
    }];
    [lookForDaRen addTapGestureRecognizer:self action:@selector(toTuiJianDaren)];
    
    [noAttentionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(superView);
        // UIScrollView的right无法attach? 用width代替
        make.width.mas_equalTo(superView.bounds.size.width);
        make.centerY.mas_equalTo(noAttentionView.superview);
        // 自动计算高度
        make.bottom.mas_equalTo(labelView);
    }];
    return noAttentionView;
}

- (void)toTuiJianDaren {
    [self toTuiJianDarenViewController];
}

- (UIView *)noRecordView {
    UIView *noRecordView = [[UIView alloc] init];
//    noRecordView.backgroundColor = [UIColor greenColor];
    UIView *superView = [self noRecordViewSuperView];
//    [superView addSubview:noRecordView];
    if (_tv.superview == superView) {
        [superView insertSubview:noRecordView aboveSubview:_tv];
    } else {
        [superView insertSubview:noRecordView atIndex:0];
    }
    _noRecordView = noRecordView;
    
    UIView *imageView = [self noRecordImageView:noRecordView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noRecordView);
        make.centerX.mas_equalTo(noRecordView);
    }];
    UIView *labelView = [self noRecordLabelView:noRecordView];
    [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).offset(NO_RECORD_VIEW_V_SPACING);
        make.left.right.mas_equalTo(noRecordView);
    }];
    [noRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(superView);
        // UIScrollView的right无法attach? 用width代替
        make.width.mas_equalTo(superView.bounds.size.width);
        make.centerY.mas_equalTo(noRecordView.superview);
        // 自动计算高度
        make.bottom.mas_equalTo(labelView);
    }];
    return noRecordView;
}

- (UIImageView *)imageViewWithImageNamed:(NSString *)imageName size:(CGSize)size superView:(UIView *)superView {
    UIImageView *imageView = [[UIImageView alloc] init];
    [superView addSubview:imageView];
    imageView.image = [UIImage imageNamed:imageName];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
    return imageView;
}

- (UIImageView *)noRecordImageView:(UIView *)superView {
    return [self imageViewWithImageNamed:@"Filter_No_Record" size:CGSizeMake(NO_RECORD_VIEW_DEFAULT_IMAGE_W, NO_RECORD_VIEW_DEFAULT_IMAGE_H) superView:superView];
}

- (NSArray *)noRecordTexts {
    return @[MZL_TABLEVIEW_FOOTER_NO_RECORD];
}

- (UIView *)noAttentionRecordLabelView:(UIView *)superView {
    UIView *labelView = [[UIView alloc] init];
    //    labelView.backgroundColor = [UIColor orangeColor];
    [superView addSubview:labelView];
    UILabel *preLabel;//
    UILabel *lbl = [[UILabel alloc] init];
    lbl.numberOfLines = 1;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = MZL_FONT(15.0);
    lbl.textColor = colorWithHexString(@"#999999");
    lbl.text = MZL_NO_ATTENTION;
    [labelView addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(labelView);
        CGFloat offset = NO_RECORD_VIEW_V_SPACING;
        if (preLabel) {
            make.top.mas_equalTo(preLabel.mas_bottom).offset(offset);
        } else {
            make.top.mas_equalTo(labelView.mas_top).offset(offset);
        }
    }];
    preLabel = lbl;
    
    [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 对齐最后一个label，自动计算高度
        make.bottom.mas_equalTo(preLabel);
    }];
    return labelView;

}

- (UIView *)noRecordLabelView:(UIView *)superView {
    UIView *labelView = [[UIView alloc] init];
//    labelView.backgroundColor = [UIColor orangeColor];
    [superView addSubview:labelView];
    UILabel *preLabel;
    for (NSString *lblText in [self noRecordTexts]) {
        UILabel *lbl = [[UILabel alloc] init];
        lbl.numberOfLines = 1;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = MZL_FONT(15.0);
        lbl.textColor = colorWithHexString(@"#d4d6d9");
        lbl.text = lblText;
        [labelView addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(labelView);
            CGFloat offset = NO_RECORD_VIEW_V_SPACING;
            if (preLabel) {
                make.top.mas_equalTo(preLabel.mas_bottom).offset(offset);
            } else {
                make.top.mas_equalTo(labelView.mas_top).offset(offset);
            }
        }];
        preLabel = lbl;
    }
    [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 对齐最后一个label，自动计算高度
        make.bottom.mas_equalTo(preLabel);
    }];
    return labelView;
}

#pragma mark - protected for footer view

- (CGFloat)footerSpacingViewHeight {
    return 15.0;
}

- (UIView *)footerSpacingView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, [self footerSpacingViewHeight])];
    return view;
}

- (void)createFooterSpacingView {
    UIView *view = [self footerSpacingView];
    if (view) {
        _tv.tableFooterView = view;
    }
}

//- (UIView *)footerNoMoreRecordView {
//    return [self footerSpacingView];
//}
//
//- (void)createFooterNoMoreRecordView {
//    UIView *view = [self footerNoMoreRecordView];
//    if (view) {
//        _tv.tableFooterView = view;
//    }
//}

- (NSString *)footerRefreshViewText {
    return nil;
}

- (UIView *)footerRefreshView {
    NSString *text = [self footerRefreshViewText];
    if (text) {
        return [_tv refreshView:text];
    } else {
        return [_tv refreshView];
    }
}

- (void)createFooterRefreshView {
    UIView *footerRefreshView = [self footerRefreshView];
    if (footerRefreshView) {
        _tv.tableFooterView = footerRefreshView;
    }
}

- (NSArray *)footerPullToRefreshViewText {
    return @[MZL_TABLEVIEW_FOOTER_PULL_TO_REFRESH];
}

- (UIView *)footerPullToRefreshView {
    UIView *view = [_tv labelsView:[self footerPullToRefreshViewText]];
    return view;
}

- (void)createFooterPullToRefreshView {
    UIView *footerPullToRefreshView = [self footerPullToRefreshView];
    if (footerPullToRefreshView) {
        _tv.tableFooterView = footerPullToRefreshView;
    }
}

- (NSArray *)footerRefreshOnReleaseViewText {
    return @[MZL_TABLEVIEW_FOOTER_REFRESH_ON_RELEASE];
}

- (UIView *)footerRefreshOnReleaseView {
    UIView *view = [_tv labelsView:[self footerRefreshOnReleaseViewText]];
    return view;
}

- (void)createFooterRefreshOnReleaseView {
    UIView *footerRefreshOnReleaseView = [self footerRefreshOnReleaseView];
    if (footerRefreshOnReleaseView) {
        _tv.tableFooterView = footerRefreshOnReleaseView;
    }
}

#pragma mark - protected for delete

- (void)deleteModelOnIndexPath:(NSIndexPath *)indexPath selector:(SEL)selector params:(NSArray *)parameters {
    [self showWorkInProgressIndicator];
    [self deleteServiceOnIndexPath:indexPath selector:selector params:parameters];
}

- (void)deleteServiceOnIndexPath:(NSIndexPath *)indexPath selector:(SEL)selector params:(NSArray *)parameters {
    __weak MZLTableViewController *weakSelf = self;
    MZL_SVC_SUCC_BLOCK succBlock = ^(NSArray *models) {
        [weakSelf onDeleteSuccBlock:models indexPath:indexPath];
    };
    MZL_SVC_ERR_BLOCK errorBlock = ^(NSError *error) {
        [weakSelf onDeleteErrorBlock:error];
    };
    [self invokeService:selector params:parameters succBlock:succBlock errorBlock:errorBlock];
}

- (void)refreshOnDelete {
}

- (void)_onDeleteSuccBlock:(NSArray *)modelsFromSvc indexPath:(NSIndexPath *)indexPath {
    }

- (void)onDeleteSuccBlock:(NSArray *)modelsFromSvc indexPath:(NSIndexPath *)indexPath {
    if (_tv.isEditing) {
        [_tv setEditing:NO animated:NO];
    }
    [_models removeObjectAtIndex:indexPath.row];
//    [_tv reloadData];
    [_tv deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self _onDeleteSuccBlock:modelsFromSvc indexPath:indexPath];
    if (_models.count < [self pageFetchCount]) {
        if (_hasMore) {
            // 不足一页数据，重新加载
            [self showNetworkProgressIndicator];
            [self refreshOnDelete];
            return;
        }
        if (_models.count == 0) {
            [self createNoRecordView];
        }
    }
    [self hideProgressIndicator];
}

- (void)onDeleteErrorBlock:(NSError *)error {
    [self onDeleteError:error];
}

#pragma mark - protected

//- (void)onNoMoreRecord {
////    _hasMore = NO;
//    [self createFooterNoMoreRecordView];
//}

- (NSInteger)pageFetchCount {
    return MZL_SVC_FETCHCOUNT;
}

- (id)invokeService:(SEL)selector params:(NSArray *)parameters succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    id result = nil;
    NSMethodSignature *signature = [MZLServices methodSignatureForSelector:selector];
    if (signature) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:[MZLServices class]];
        [invocation setSelector:selector];
        NSUInteger methodParamLen = signature.numberOfArguments;
        NSMutableArray *params = [NSMutableArray arrayWithArray:parameters];
        [params addObject:succBlock];
        [params addObject:errorBlock];
        // 如果该方法存在参数（len >2, 0为方法拥者，1为方法名)
        if (methodParamLen > 2) {
            for (int i = 2; i < methodParamLen ; i++) {
                id param = params[i - 2];
                [invocation setArgument:&param atIndex:i];
            }
        }
        [invocation invoke];
        if (signature.methodReturnLength > 0) {
            result = [invocation objectReturnValue];
        }
    }
    return result;
}

@end
