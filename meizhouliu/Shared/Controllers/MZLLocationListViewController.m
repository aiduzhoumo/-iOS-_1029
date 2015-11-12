//
//  MZLLocationListViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-15.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLLocationListViewController.h"
#import "MZLRecommendLocationItemCell.h"
#import "UIImageView+MZLNetwork.h"
#import "MZLServices.h"
#import "MZLModelLocation.h"
#import "MZLLocationDetailViewController.h"
#import "MobClick.h"
#import <IBMessageCenter.h>
#import "MZLSharedData.h"
#import "MZLLocListResponse.h"
#import "UITableView+MZLHeaderFooterView.h"
#import "MZLPagingSvcParam.h"
#import "WeView.h"
#import "MZLBaseViewController+CityList.h"
#import "MZLFilterParam.h"
#import "UIScrollView+MZLAddition.h"

#define SEGUE_LOCATIONTODETAIL @"locationToLocationDetail"

#define SECTION_DEFAULT_LOCATIONS 0
#define SECTION_MORE_LOCATIONS 1

@interface MZLLocationListViewController () {
    MZLLocListResponse *_locationList;
    
    BOOL _ignoreScrollEvent;
}

@end

@implementation MZLLocationListViewController

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
    _tv = self.tvLocationList;
    _tv.backgroundColor = MZL_BG_COLOR();
//    [self addCityListDropdownBarButtonItem];
//    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_LOCATION_UPDATED target:self action:@selector(onLocationUpdated)];
    
//    [self launchToLocationDetail];
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
    [self adjustTableViewBottomInset:MZL_TAB_BAR_HEIGHT scrollIndicatorBottomInset:MZL_TAB_BAR_HEIGHT];
}

- (NSString *)statsID {
    return @"目的地推荐页";
}


#pragma mark - override

- (void)loadModels {
    _locationList = nil;
    [super loadModels];
}

- (NSArray *)noRecordTextsWithFilters {
    return @[@"对不起啊，", @"没有找到你个性化需求的目的地，", @"请重新选择。"];
}

///** 没有选中目的地不能调用filter service，所以需要额外判断 */
//- (BOOL)hasFilters {
//    BOOL resultFromSuper = [super hasFilters];
//    BOOL hasCity = ! isEmptyString([MZLSharedData selectedCity]);
//    return resultFromSuper && hasCity;
//}

- (BOOL)_shouldShowFilterView {
    return NO;
}

//#pragma mark - location service and delegate
//
//- (void)onLocationUpdated {
//    [self changeCityLabelText];
//    [self loadModelsWhenViewIsVisible];
//}

//#pragma mark - city list
//
//- (void)showCityList {
//    [MobClick event:@"clickLocationListCity"];
//    [super showCityList];
//}

#pragma mark - data loading

- (NSString *)selectedCity {
    NSString *result = [MZLSharedData selectedCity];
    return isEmptyString(result) ? @"" : result;
}

//- (void)loadLocations {
//    _locationList = nil;
//    [self loadModels];
//}

#pragma mark - protected for load

- (void)_loadModelsWithoutFilters {
    self.title = @"目的地推荐";
    [self invokeService:@selector(locationListServiceFromCurrentLocation:succBlock:errorBlock:) params:@[[self selectedCity]]];
}

//- (void)_loadModelsWithFilters:(MZLFilterParam *)filter {
//    self.title = @"个性化推荐";
//    filter.destinationName = [MZLSharedData selectedCity];
//    [self invokeService:@selector(filterLocationsServiceWithParam:succBlock:errorBlock:) params:@[filter]];
//}

- (BOOL)isModelLocationList:(NSArray *)modelsFromSvc {
    return modelsFromSvc.count == 0 || [modelsFromSvc[0] isMemberOfClass:[MZLModelLocation class]];
}

- (NSMutableArray *)mapModelsOnLoad:(NSArray *)modelsFromSvc {
    if ([self isModelLocationList:modelsFromSvc]) {
        return [super mapModelsOnLoad:modelsFromSvc];
    }
    _locationList = modelsFromSvc[0];
    NSMutableArray *result = [NSMutableArray array];
    if ([_locationList isSpecialLocationList]) {
        _isMultiSections = YES;
        NSArray *locationList = [NSArray arrayWithArray:_locationList.destinations];
        NSArray *relatedLocationList = [NSArray arrayWithArray:_locationList.more];
        [result addObject:locationList];
        [result addObject:relatedLocationList];
    } else {
        [result addObjectsFromArray:_locationList.destinations];
    }
    return result;
}

#pragma mark - protected for load more

- (BOOL)_canLoadMore {
    return [_locationList isDefaultLocationList] || [self hasFilters];
}

//- (void)_loadMoreWithFilters:(MZLFilterParam *)filter {
//    filter.destinationName = [MZLSharedData selectedCity];
//    [self invokeLoadMoreService:@selector(filterLocationsServiceWithParam:succBlock:errorBlock:) params:@[filter]];
//}

- (void)_loadMoreWithoutFilters:(MZLPagingSvcParam *)pagingParam {
    [self invokeLoadMoreService:@selector(locationListServiceFromCurrentLocation:pagingParam:succBlock:errorBlock:) params:@[[self selectedCity], pagingParam]];
}

- (NSArray *)mapModelsOnLoadMore:(NSArray *)modelsFromSvc {
    if ([self isModelLocationList:modelsFromSvc]) {
        return [super mapModelsOnLoadMore:modelsFromSvc];
    }
    // 因为只有default类型的list有分页，暂只考虑这种情况
    MZLLocListResponse *response = modelsFromSvc[0];
    return response.destinations;
}

//#pragma mark - filter delegate
//
//- (void)onFilterOptionsWillShow {
//    _ignoreScrollEvent = YES;
//}
//
//- (void)onFilterOptionsHidden {
//    [super onFilterOptionsHidden];
//    _ignoreScrollEvent = NO;
//}
//
//- (BOOL)onLocationNotDetermined {
//    _ignoreScrollEvent = YES;
//    [self showCityListOnLocationNotDetermined];
//    return NO;
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:SEGUE_LOCATIONTODETAIL]) {
        MZLLocationDetailViewController *vcLocationDetail = (MZLLocationDetailViewController *)segue.destinationViewController;
        vcLocationDetail.locationParam = sender;
    }
}

#pragma mark - scroll view delegate

//- (BOOL)shouldIgnoreScroll {
//    return _ignoreScrollEvent;
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [super scrollViewDidScroll:scrollView];
//    [self trackYOnScroll:scrollView];
//}

#pragma mark - table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLModelLocation *location = [self modelObjectForIndexPath:indexPath];
    MZLRecommendLocationItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationItemCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lblLocationName.text = location.name;
    cell.lblLocationDetail.text = location.introduction;
    cell.lblArticleCount.text = INT_TO_STR(location.shortArticleCount);
    cell.lblLocationName.textColor = MZL_COLOR_BLACK_555555();
    cell.lblLocationDetail.textColor = MZL_COLOR_BLACK_999999();
    cell.lblArticleCount.textColor = colorWithHexString(@"#f0a0a0");
    cell.lblArticleCountTip.textColor = MZL_COLOR_BLACK_999999();
    [cell.imgBg loadBigLocationImageFromURL:location.coverImageUrl];
    [cell.vwBg.layer setCornerRadius:5.0];
    
    return cell;
}

#pragma mark - table view delegate

#define HEIGHT_HEADER_VIEW 43.0

- (UIView *)labelView:(NSString *)textToDisplay {
    WeView *result = [[WeView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tv.bounds.size.width, HEIGHT_HEADER_VIEW)];
    UILabel *lbl = [[UILabel alloc] init];
    [lbl setFont:MZL_FONT(MZL_TABLEVIEW_HEADER_FONT_SIZE)];
    [lbl setText:textToDisplay];
    [lbl setTextColor:MZL_COLOR_BLACK_999999()];
    lbl.numberOfLines = 0;
    [[[result addSubviewsWithVerticalLayout:@[lbl]] setHMargin:15.0] setTopMargin:8.0];
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([_locationList isSystemLocationList]) {
        return HEIGHT_HEADER_VIEW;
    } else if ([_locationList isSpecialLocationList] && section == SECTION_MORE_LOCATIONS) {
        return HEIGHT_HEADER_VIEW;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([_locationList isSystemLocationList]) {
        return [self labelView:@"很抱歉，你的周边暂时没有特别推荐的目的地，我们正在努力奋斗挖掘中。先看看其他有趣的目的地吧"];
    } else if ([_locationList isSpecialLocationList] && section == SECTION_MORE_LOCATIONS) {
        return [self labelView:@"很抱歉，你的周边推荐目的地不多哦，也看看稍远一点的地方吧"];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 298.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLModelLocation *location = [self modelObjectForIndexPath:indexPath];
    [MobClick event:@"clickRecommendedLocations" label:location.name];
    [self performSegueWithIdentifier:SEGUE_LOCATIONTODETAIL sender:location];
}

//#pragma mark - notification launchToLocationDetail
//
//- (void)launchToLocationDetail {
//    if (! [MZLSharedData apsInfo]) {
//        return;
//    }
//    if (!isEmptyString([[[MZLSharedData apsInfo] valueForKey:@"destination"] valueForKey:@"id"])) {
//        MZLModelLocationBase *location = [[MZLModelLocationBase alloc] init];
//        location.identifier = [[[[MZLSharedData apsInfo] valueForKey:@"destination"] valueForKey:@"id"] intValue];
//        UIStoryboard *storyboard = [self storyboard];
//        MZLLocationDetailViewController * vcLocationDetail = (MZLLocationDetailViewController *) [storyboard instantiateViewControllerWithIdentifier:@"MZLLocationDetailViewController"];
//        vcLocationDetail.locationParam = location;
//        [self.navigationController pushViewController:vcLocationDetail animated:YES];
//        [MZLSharedData setApnsInfo:nil];
//    }
//}

@end
