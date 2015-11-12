//
//  MZLChildLocationsViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-28.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLChildLocationsViewController.h"

#import "MZLModelLocation.h"
#import "MZLLocationItemCell.h"
#import "MZLChildLocationsSvcParam.h"
#import "MZLPagingSvcParam.h"
#import "MZLServices.h"
#import "MobClick.h"
#import "MZLModelFilterType.h"
#import "UIScrollView+MZLAddition.h"
#import "MZLFilterParam.h"
#import "UIView+MZLAdditions.h"
#import "MZLModelRelatedLocation.h"

@interface MZLChildLocationsViewController () {
}

@end

@implementation MZLChildLocationsViewController

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
    [self.navigationTitle setText:self.locationParam.name];
    self.navigationTitle.textColor = MZL_NAVBAR_TITLE_COLOR();
    self.navigationTitle.font = MZL_NAVBAR_TITLE_FONT();
    
    _tv = self.tvChildLocations;
    _tv.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_tv setBackgroundColor:MZL_BG_COLOR()];
    [_tv removeUnnecessarySeparators];
    UIEdgeInsets edgeInsets = _tv.contentInset;
    edgeInsets.bottom = MZL_TAB_BAR_HEIGHT;
    _tv.contentInset = edgeInsets;
    [_tv mzl_setInsetsForContentAndIndicator:edgeInsets];
    self.scMyTop.constant = MZL_TOP_BAR_HEIGHT;
    self.scMy.tintColor = MZL_COLOR_YELLOW_FDD414();
    [self.scMy addTarget:self action:@selector(controlEventValueChanged) forControlEvents:UIControlEventValueChanged];
    [self addSeparatorLine];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - add separator line

- (void)addSeparatorLine {
    UIView *view = [self.vwTop createBottomSepView];
    view.backgroundColor = MZL_SEPARATORS_BG_COLOR();
}

#pragma mark - protected override

- (NSArray *)noRecordTextsWithFilters {
    return @[@"对不起啊，", @"没有找到你个性化需求的目的地，", @"请重新选择。"];
}

- (NSArray *)noRecordTextsWithoutFilters {
    return @[MZL_CHILD_LOCATION_NO_RECORD];
}

- (NSArray *)_filterOptions {
    return [MZLModelFilterType excludeDistanceTypeFromFilters:[MZLSharedData filterOptions]];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [super prepareForSegue:segue sender:sender];
}

#pragma mark - UISegmentedControl methods

- (void)controlEventValueChanged {
    [self loadModels];
    [self umengEvent:self.scMy.selectedSegmentIndex];
}

#pragma mark - helper methods

- (MZLChildLocationsSvcParam *)childLocationsSvcParam {
    MZLChildLocationsSvcParam *param = [[MZLChildLocationsSvcParam alloc] init];
    param.parentLocationId = self.locationParam.identifier;
    param.pagingParam = [self pagingParamFromModels];
    param.category = self.scMy.selectedSegmentIndex;
    return param;
}

#pragma mark - protected for load

- (void)_loadModelsWithoutFilters {
    MZLFilterParam *filter = [MZLFilterParam filterParamsFromFilterTypes:[NSArray array]];
    MZLChildLocationsSvcParam *param = [self childLocationsSvcParam];
     [self invokeService:@selector(relatedLocationPersonalizeService:param:succBlock:errorBlock:) params:@[param, filter]];
}

- (void)_loadModelsWithFilters:(MZLFilterParam *)filter {
    MZLChildLocationsSvcParam *param = [self childLocationsSvcParam];
    [self invokeService:@selector(relatedLocationPersonalizeService:param:succBlock:errorBlock:) params:@[param, filter]];
}

#pragma mark - protected for load more

- (BOOL)_canLoadMore {
    return YES;
}

- (void)_loadMoreWithoutFilters:(MZLPagingSvcParam *)pagingParam {
    MZLFilterParam *filter = [MZLFilterParam filterParamsFromFilterTypes:[NSArray array]];
    MZLChildLocationsSvcParam *param = [self childLocationsSvcParam];
    [self invokeLoadMoreService:@selector(relatedLocationPersonalizeService:param:succBlock:errorBlock:) params:@[param, filter]];
}

- (void)_loadMoreWithFilters:(MZLFilterParam *)filter {
    MZLChildLocationsSvcParam *param = [self childLocationsSvcParam];
    [self invokeLoadMoreService:@selector(relatedLocationPersonalizeService:param:succBlock:errorBlock:) params:@[param, filter]];
}


#pragma mark - table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_models.count > 0) {
        MZLLocationItemCell *cell = [_tv dequeueReusableLocationItemCell];
        if (! cell.isVisted) {
            [cell updateOnFirstVisit];
        }
        cell.parentLocation = self.locationParam;
        [cell updateContentFromRelatedLocation:_models[indexPath.row]];
        return cell;
    }
    return nil;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MZL_LOCATIONCELL_HEIGHT; //_models.count > 0 ? 106.0 : [self cellHeightForNoResult];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self toLocationDetail:indexPath];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self toLocationDetail:indexPath];
}

- (void)toLocationDetail:(NSIndexPath *)indexPath {
    MZLModelRelatedLocation *location = _models[indexPath.row];
    [self performSegueWithIdentifier:MZL_SEGUE_TOLOCATIONDETAIL sender:location];
}

#pragma mark - Umeng 
- (void)umengEvent:(NSInteger)segmentIndex {
    NSArray *arrCategory = @[@"全部",@"景点",@"住宿",@"美食",@"其它"];
    NSArray *arrUmengEvents = @[@"clickChildLocationsTotal",
                                @"clickChildLocationsViewspot",
                                @"clickChildLocationsAccommodation",
                                @"clickChildLocationsCatering",
                                @"clickChildLocationsOthers"];
    
    [MobClick event:arrUmengEvents[self.scMy.selectedSegmentIndex]];
    [MobClick event:@"clickChildLocationsTabBarTotal" label:arrCategory[self.scMy.selectedSegmentIndex]];
}

#pragma mark - stats

- (NSString *)statsID{
    return @"子目的地页";
}

#pragma mark - protected filter related

#define MZL_ANIMATION_DURATION 0.4

- (void)onFilterOptionsWillShow {
    self.scMyTop.constant = MZL_NAV_BAR_HEIGHT;
    [UIView animateWithDuration:MZL_ANIMATION_DURATION animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)onFilterOptionsWillHide {
    self.scMyTop.constant = MZL_TOP_BAR_HEIGHT;
    [UIView animateWithDuration:MZL_ANIMATION_DURATION animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
