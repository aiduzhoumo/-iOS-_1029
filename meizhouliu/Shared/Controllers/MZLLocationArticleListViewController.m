    //
//  MZLLocationArticleListViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-6-26.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLLocationArticleListViewController.h"
#import "MZLModelLocationBase.h"
#import "MZLServices.h"
#import "MZLArticleListSvcParam.h"
#import "MZLModelArticle.h"
#import "MZLModelFilterType.h"
#import "MZLFilterParam.h"
#import "UIScrollView+MZLAddition.h"
#import "MZLArticleDetailViewController.h"
#import "MZLShortArticleCell.h"
#import "UIViewController+MZLShortArticle.h"
#import "UIView+MZLAdditions.h"
#import "UIImageView+MZLNetwork.h"
#import "MZLModelUserLocationPref.h"
#import "MZLLoginViewController.h"
#import "UIViewController+MZLAdditions.h"
#import "MZLUserLocPrefResponse.h"
#import "MZLLocationDetailViewController.h"

@interface MZLLocationArticleListViewController () {
    BOOL _ignoreScrollEventOnToggleNavBar;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgNav;
@property (weak, nonatomic) IBOutlet UILabel *lblLocationName;
@property (weak, nonatomic) IBOutlet UIButton *btnFavor;

- (IBAction)toMap:(id)sender;

@end

@implementation MZLLocationArticleListViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    self.view.backgroundColor = MZL_BG_COLOR();
    _tv.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    _tv.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tv.separatorColor = @"D8D8D8".co_toHexColor;
    
    UIEdgeInsets inset = _tv.contentInset;
//    inset.top = MZL_NAV_BAR_HEIGHT;
    inset.bottom = MZL_TAB_BAR_HEIGHT;
    _tv.contentInset = inset;
//    inset.top = MZL_TOP_BAR_HEIGHT;
//    _tv.scrollIndicatorInsets = inset;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:MZL_SEGUE_TOARTICLEDETAIL]) {
        MZLArticleDetailViewController *vcArticleDetail = (MZLArticleDetailViewController *)segue.destinationViewController;
        // 在超类的基础上增加跳转地点
        vcArticleDetail.targetLocation = self.locationParam;
    }
}

- (IBAction)back:(id)sender {
    [self backToParent];
}

- (IBAction)toLocationInfo:(id)sender {
    [self.ownerVc toLocationInfo];
}

- (IBAction)toMap:(id)sender {
    [self.ownerVc toMap];
}

- (void)initHeaderView {
    // Create ParallaxHeaderView with specified size, and set it as uitableView Header, that's it
    ParallaxHeaderView *headerView = [ParallaxHeaderView parallaxHeaderViewWithImageUrl:_locationParam.coverImageUrl forSize:CGSizeMake(CO_SCREEN_WIDTH, 280)];
    headerView.delegate = self;
    headerView.headerTitleLabel.text = self.locationParam.name;
    [_tv setTableHeaderView:headerView];
    self.lblLocationName.text = self.locationParam.name;
    [self.btnFavor addTarget:self.ownerVc action:@selector(toggleFavor) forControlEvents:UIControlEventTouchUpInside];
    [self toggleFavoredImage:_locUserPref];
}

- (UIView *)viewForSectionHeader {
    CGRect sectionHeaderRect = CGRectMake(0, 0, CO_SCREEN_WIDTH, 48);
    UIView *viewForHeaderInSection = [[UIView alloc] initWithFrame:sectionHeaderRect];
    if (_models.count == 0) {
        viewForHeaderInSection.backgroundColor = self.view.backgroundColor;
        UILabel *lbl = [viewForHeaderInSection createSubViewLabelWithFontSize:12 textColor:@"999999".co_toHexColor];
        lbl.text = @"暂无玩法";
        [lbl co_centerParent];
    } else {
        viewForHeaderInSection.backgroundColor = [UIColor whiteColor];
        UIImageView *innerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_article"]];
        [viewForHeaderInSection addSubview:innerImageView];
        [innerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(innerImageView.superview);
            make.width.equalTo(@16);
            make.height.equalTo(@16);
        }];
        
        UIView *innerLineLeft = [viewForHeaderInSection createSubView];
        innerLineLeft.backgroundColor = colorWithHexString(@"#d8d8d8");
        [innerLineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(innerLineLeft.superview.mas_left).offset(15);
            make.right.equalTo(innerImageView.mas_left).offset(-15);
            make.centerY.equalTo(innerImageView.superview.mas_centerY);
            make.height.equalTo(@0.5);
        }];
        
        UIView *innerLineRight = [viewForHeaderInSection createSubView];
        innerLineRight.backgroundColor = colorWithHexString(@"#d8d8d8");
        [innerLineRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(innerImageView.mas_right).offset(15);
            make.right.equalTo(innerLineRight.superview.mas_right).offset(-15);
            make.centerY.equalTo(innerImageView.superview.mas_centerY);
            make.height.equalTo(@0.5);
        }];
    }
    
    return viewForHeaderInSection;
}

#pragma mark - protected override

- (void)initControls {
    [super initControls];
    [self initHeaderView];
    self.lblTitle.textColor = MZL_NAVBAR_TITLE_COLOR();
    self.lblTitle.font = MZL_NAVBAR_TITLE_FONT();
    self.lblTitle.text = self.locationParam.name;
}

- (NSArray *)_filterOptions {
    return [MZLModelFilterType excludeDistanceTypeFromFilters:[MZLSharedData filterOptions]];
}

- (NSInteger)pageFetchCount {
    return MZL_SHORT_ARTICLE_PAGE_FETCH_COUNT;
}

- (UIView *)footerSpacingView {
    UIView *view = [super footerSpacingView];
    [view createTopSepView];
    return view;
}

- (UIView *)noRecordView {
    return nil;
}

#pragma mark - protected for load

- (void)_loadModelsWithFilters:(MZLFilterParam *)filter {
    MZLPagingSvcParam *pagingParam = [self pagingParamFromModels];
    [self invokeService:@selector(locationArticleListServiceWithLocation:pagingParam:filter:succBlock:errorBlock:) params:@[self.locationParam, pagingParam, filter]];
//    [self invokeService:@selector(filterLocationArticlesServiceOnLocation:param:succBlock:errorBlock:) params:@[self.locationParam, filter]];
}

- (void)_loadModelsWithoutFilters {
//    [self invokeService:@selector(locationArticleListServiceWithLocationId:succBlock:errorBlock:) params:@[@(self.locationParam.identifier)]];
    MZLPagingSvcParam *pagingParam = [self pagingParamFromModels];
    [self invokeService:@selector(locationArticleListServiceWithLocation:pagingParam:succBlock:errorBlock:) params:@[self.locationParam, pagingParam]];
}

#pragma mark - protected for load more

- (void)_loadMoreWithFilters:(MZLFilterParam *)filter {
//    [self invokeLoadMoreService:@selector(filterLocationArticlesServiceOnLocation:param:succBlock:errorBlock:) params:@[self.locationParam, filter]];
    MZLPagingSvcParam *pagingParam = filter.pagingParam;
    
    [self invokeLoadMoreService:@selector(locationArticleListServiceWithLocation:pagingParam:filter:succBlock:errorBlock:) params:@[self.locationParam, pagingParam, filter]];
}

- (void)_loadMoreWithoutFilters:(MZLPagingSvcParam *)pagingParam {
    [self invokeLoadMoreService:@selector(locationArticleListServiceWithLocation:pagingParam:succBlock:errorBlock:) params:@[self.locationParam, pagingParam]];
}

//- (void)_loadMoreArticlesWithoutFilters:(MZLArticleListSvcParam *)param {
//    param.locationId = self.locationParam.identifier;
//    [self invokeLoadMoreService:@selector(locationArticleListServiceWithLocation:pagingParam:succBlock:errorBlock:) params:@[param]];
//}

#pragma mark - table data source and delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLShortArticleCell *cell = [MZLShortArticleCell cellWithTableview:tableView type:MZLShortArticleCellTypeLocation model:_models[indexPath.row]];
//    cell.ownerController = self;
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return MZLSAC_EST_HEIGHT;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MZLShortArticleCell heightForTableView:tableView withType:MZLShortArticleCellTypeLocation withModel:_models[indexPath.row]];
//    return [MZLShortArticleCell heightFromType:MZLShortArticleCellTypeLocation model:_models[indexPath.row]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self viewForSectionHeader];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tv) {
        // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
        [(ParallaxHeaderView *)_tv.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
//        self.lblLocationName.alpha = scrollView.contentOffset.y/(_tv.tableHeaderView.height - self.imgNav.height) ;
    }
    [super scrollViewDidScroll:scrollView];
}

#pragma mark - ParallaxHeaderViewDelegate 

- (void)parallaxShowNavigationView {
    if (!self.imgNav.image) {
        self.imgNav.image = ((ParallaxHeaderView *)_tv.tableHeaderView).navImage;
        self.lblLocationName.alpha = 1;
    }
}

- (void)parallaxHiddenNavigationView {
    if(self.imgNav.image) {
        self.imgNav.image = nil;
        self.lblLocationName.alpha = 0;
    }
}

#pragma mark - statsID

- (NSString *)statsID {
    return @"目的地文章列表";
}

#pragma mark - protected filter related

#define MZL_ANIMATION_DURATION 0.4

- (void)onFilterOptionsWillShow {
    [UIView animateWithDuration:MZL_ANIMATION_DURATION animations:^{
        CGPoint offset = _tv.contentOffset;
        offset.y += 20.0;
        _tv.contentOffset = offset;
    }];
}

- (void)onFilterOptionsWillHide {
    [UIView animateWithDuration:MZL_ANIMATION_DURATION animations:^{
        CGPoint offset = _tv.contentOffset;
        offset.y -= 20.0;
        _tv.contentOffset = offset;
    }];
}

- (void)toggleFavoredImage:(MZLModelUserLocationPref *)userLocPref {
    [self.btnFavor setBackgroundImage:[self imageForFavoredLocation:userLocPref] forState:UIControlStateNormal];
}

- (UIImage *)imageForFavoredLocation:(MZLModelUserLocationPref *)userLocPref{
    if (userLocPref.locationId) {
        return [UIImage imageNamed:@"Location_Interested"];
    } else {
        return [UIImage imageNamed:@"Location_Interest_White"];
    }
}

@end
