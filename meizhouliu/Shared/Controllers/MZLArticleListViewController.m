//
//  MZLArticleListViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-8.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLArticleListViewController.h"
#import "WeView.h"
#import "MZLFilterParam.h"
#import "MZLServices.h"

#define MAX_DISPLAY_ARTICLE_COUNT 200

@interface MZLArticleListViewController () {
}

@end

@implementation MZLArticleListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initControls];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _ignoreScrollEvent = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _ignoreScrollEvent = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self adjustTableViewInsets];
}

#pragma mark - protected for override

- (void)initControls {
    self.view.backgroundColor = MZL_BG_COLOR();
    
    _tv = self.tvArticleList;
    _tv.backgroundColor = [UIColor clearColor];
    _tv.tableHeaderView = [self defaultHeaderView];
}

- (void)loadModels {
    [super loadModels];
}

#pragma mark - protected override

- (NSArray *)noRecordTextsWithFilters {
    return @[@"对不起啊，", @"没有找到你个性化需求的玩法，", @"请重新选择。"];
}

#pragma mark - table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self articleItemCellAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section];
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self articleItemCellHeight:indexPath];
}

#pragma mark - protected for table footer

- (CGFloat)footerSpacingViewHeight {
    return ARTICLE_CELL_DEFAULT_BOTTOM_MARGIN;
}

#pragma mark - protected for load more

- (void)_loadMoreWithoutFilters:(MZLPagingSvcParam *)pagingParam {
    MZLArticleListSvcParam * articleSvcParam = [[MZLArticleListSvcParam alloc]init];
    [articleSvcParam setPaging:pagingParam];
    [self _loadMoreArticlesWithoutFilters:articleSvcParam];
}

- (void)_loadMoreArticlesWithoutFilters:(MZLArticleListSvcParam *)param {
}

//- (void)_onLoadMoreSuccBlock:(NSArray *)modelsFromSvc {
//    if (_models.count >= MAX_DISPLAY_ARTICLE_COUNT) {
//        _tv.tableFooterView = nil;
//    }
//}

- (BOOL)_canLoadMore {
    return _models.count < MAX_DISPLAY_ARTICLE_COUNT;
}

#pragma mark - scroll view delegate

//- (BOOL)shouldIgnoreScroll {
//    return _ignoreScrollEvent;
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [super scrollViewDidScroll:scrollView];
//    [self trackYOnScroll:scrollView];
//}

#pragma mark - helper

- (UIView *)defaultHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tv.width, MZL_ARTICLE_LIST_VC_TV_MARGIN)];
    return view;
}

#pragma mark - filter delegate

- (void)onFilterOptionsWillShow {
    _ignoreScrollEvent = YES;
}

- (void)onFilterOptionsHidden {
    [super onFilterOptionsHidden];
    _ignoreScrollEvent = NO;
}

@end
