//
//  MZLAuthorDetailViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-22.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLAuthorDetailViewController.h"
#import "UITableView+MZLAdditions.h"
#import "MZLArticleItemTableViewCell.h"
#import "MZLModelArticle.h"
#import "MZLModelImage.h"
#import "MZLModelAuthor.h"
#import "MZLModelLocation.h"
#import "UIImageView+MZLNetwork.h"
#import "MZLServices.h"
#import "MZLPagingSvcParam.h"
#import "MZLNormalAuthorHeader.h"
#import "MZLSignedAuthorHeader.h"
#import "MobClick.h"
#import "MZLShortArticleCell.h"
#import "UIViewController+MZLShortArticle.h"
#import "MZLModelUser.h"
#import "MZLFeriendListViewController.h"
#import "View+MASAdditions.h"


@interface MZLAuthorDetailViewController ()<MZLAuthorHeaderShowProgressIndicatorDelegate> {
    MZLModelUser *_authorDetail;
}

@property (nonatomic, assign) int m;
@end

@implementation MZLAuthorDetailViewController

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
    
    self.m = 0;
    // Do any additional setup after loading the view.
    _tv = self.tvAuthor;
    self.navigationItem.title = @"";
    self.tvAuthor.tableHeaderView = nil;
    self.tvAuthor.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tvAuthor.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self loadAuthorDetail];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //应该是要刷新关注按钮的状态的
    if (self.m != 0) {
        [self initUI];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    self.m = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)statsID {
    return @"作者详情页";
}

#pragma mark - author detail

- (void)loadAuthorDetail {
    [self showNetworkProgressIndicator];
    [MZLServices authorDetailService:@(self.authorParam.identifier) succBlock:^(NSArray *models) {
        _authorDetail = models[0];
        [self loadModels];
    } errorBlock:^(NSError *error) {
        [self onNetworkError];
    }];
}

#pragma mark - override

- (CGFloat)footerSpacingViewHeight {
//    return ARTICLE_CELL_DEFAULT_BOTTOM_MARGIN;
    return 0;
}

- (NSInteger)pageFetchCount {
    return MZL_SHORT_ARTICLE_PAGE_FETCH_COUNT;
}

- (void)createNoRecordView {
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  200)];
    [_tv.tableFooterView addSubview:tempView];
    
    UIView *noRecordView = [[UIView alloc] init];
    [tempView addSubview:noRecordView];
    
    UIView *imageView = [self noRecordImageView:noRecordView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noRecordView);
        make.centerX.mas_equalTo(noRecordView);
    }];
    UIView *labelView = [self noRecordLabelView:noRecordView];
    [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).offset(3);
        make.left.right.mas_equalTo(noRecordView);
    }];
    [noRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tempView);
        // UIScrollView的right无法attach? 用width代替
        make.width.mas_equalTo(tempView.bounds.size.width);
        make.centerY.mas_equalTo(noRecordView.superview);
        // 自动计算高度
        make.bottom.mas_equalTo(labelView);
    }];
}

#pragma mark - protected for load

- (void)_loadModels {
    MZLPagingSvcParam *param = [self pagingParamFromModels];
    [self invokeService:@selector(authorShortArticleListWithAuthor:pagingParam:succBlock:errorBlock:) params:@[self.authorParam, param]];
}

- (void)_onLoadSuccBlock:(NSArray *)modelsFromSvc {
    [self initUI];
}

- (void)initUI {
    _authorDetail.isAttentionForCurrentUser = self.authorParam.isAttention;
    if ([_authorDetail isSignedAuthor]) { // 签约作者
        self.navigationItem.title = MZL_AUTHOR_IS_SIGNED_WRITER;
        MZLAuthorHeader *headerView = (MZLAuthorHeader *)[MZLSignedAuthorHeader signedAuthorHeader:_authorDetail];
        headerView.delegate = self;
        self.tvAuthor.tableHeaderView = headerView;
        headerView.clickBlcok = ^(MZLModelUser *user,feriendListKind listKind) {
            MZLFeriendListViewController *feriendList = [MZL_MAIN_STORYBOARD() instantiateViewControllerWithIdentifier:@"MZLFeriendListViewController"];
            if (listKind == feriendListKindAttention) {
                feriendList.listKind = seleFeriendListKindAttention;
            }else if (listKind == feriendListKindFensi){
                feriendList.listKind = seleFeriendListKindFensi;
            }
            feriendList.user = user;
            feriendList.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:feriendList animated:YES];
        };
    } else {
        self.navigationItem.title = MZL_AUTHOR_NOT_SIGNED_WRITER;
        MZLAuthorHeader *headerView = [MZLNormalAuthorHeader normalAuthorHeader:_authorDetail];
        self.tvAuthor.tableHeaderView = headerView;
        headerView.delegate = self;
        headerView.clickBlcok = ^(MZLModelUser *user,feriendListKind listKind) {
            MZLFeriendListViewController *feriendList = [MZL_MAIN_STORYBOARD() instantiateViewControllerWithIdentifier:@"MZLFeriendListViewController"];
            if (listKind == feriendListKindAttention) {
                feriendList.listKind = seleFeriendListKindAttention;
            }else if (listKind == feriendListKindFensi){
                feriendList.listKind = seleFeriendListKindFensi;
            }
            feriendList.user = user;
            feriendList.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:feriendList animated:YES];
        };
    }
    self.view.backgroundColor = MZL_BG_COLOR();
}

- (NSArray *)noRecordTexts {
    return @[MZL_AUTHOR_DETAIL_NO_RECORD];
}

#pragma mark - MZLAuthorHeaderShowProgressIndicatorDelegate
- (void)showProgressIndicatorAlertViewOnAuthorDetailVC {
    [self showNetworkProgressIndicator];
}

- (void)hideProgressIndicatorAlertViewOnAuthorDetailVC:(BOOL)isSuccess {
    if (isSuccess == 1) {
        [self hideProgressIndicator];
    }else {
        [self hideProgressIndicator];
        [self onNetworkError];
    }
}
#pragma mark - loading more

- (BOOL)_canLoadMore {
    return YES;
}

- (void)_loadMore {
    MZLPagingSvcParam *param = [self pagingParamFromModels];
    [self invokeLoadMoreService:@selector(authorShortArticleListWithAuthor:pagingParam:succBlock:errorBlock:) params:@[self.authorParam, param]];
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

#pragma mark - table view data source and delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLShortArticleCell *cell = [MZLShortArticleCell cellWithTableview:tableView type:MZLShortArticleCellTypeAuthor model:_models[indexPath.row]];
//    cell.ownerController = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [MZLShortArticleCell heightFromType:MZLShortArticleCellTypeAuthor model:_models[indexPath.row]];
    return [MZLShortArticleCell heightForTableView:tableView withType:MZLShortArticleCellTypeAuthor withModel:_models[indexPath.row]];
}


@end
