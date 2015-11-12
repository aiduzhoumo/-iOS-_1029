//
//  MZLPersonalizedViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-11-25.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLPersonalizedViewController.h"
#import "MZLBaseViewController+CityList.h"
#import "MZLPersonalizedItemCell.h"
#import <IBMessageCenter.h>
#import "UIView+MZLAdditions.h"
#import <Masonry/Masonry.h>
#import "MZLServices.h"
#import "MZLSharedData.h"
#import "MZLModelLocationDetail.h"
#import "MZLArticleDetailViewController.h"
#import "MZLLocationDetailViewController.h"
#import "UIViewController+MZLiVersionSupport.h"
#import "UIViewController+MZLLocationSupport.h"

#import "MZLFilterParam.h"
#import "MZLModelArticleDetail.h"
#import "MZLTabBarViewController.h"
#import "MZLPersonalizeSvcParam.h"
#import "UIImage+COAdditions.h"
#import "NSString+COPinYin4ObjcAddition.h"


#define HEIGHT_TOP_SECTION 36
#define TYPE_CAT 1
#define TYPE_CITY 2

NSArray *allLocationCategories() {
    return @[@"全部分类", @"景点", @"住宿", @"美食", @"其它"];
}

NSArray *allLocationCatImages() {
    return @[@"Loc_Cat_All", @"Loc_Cat_Viewspot", @"Loc_Cat_Lodge", @"Loc_Cat_Catering", @"Loc_Cat_Others"];
}

@interface MZLPersonalizedTopLocation : MZLModelLocationDetail

@property (nonatomic, readonly) NSInteger articleCountFromAllChildLocations;
@property (nonatomic, assign) NSInteger visibleChildLocationCount;
@property (nonatomic, strong) NSString *pinyinString;

- (BOOL)hasMoreChildLocations;

@end

@interface MZLTableDropdownView : UIView <UITableViewDataSource, UITableViewDelegate> {
    __weak UITableView *_tv;
}

@property (nonatomic, assign) NSInteger displayType;
@property (nonatomic, copy) NSArray *ds;
@property (nonatomic, weak) MZLPersonalizedViewController *vc;

- (BOOL)isShown;
- (void)show;
- (void)hide;

+ (MZLTableDropdownView *)instance;

@end

@interface MZLPersonalizedViewController () {
    MZLTableDropdownView *_tableDropdown;
    
    NSMutableArray *_topSectionViews;
    /** 下拉列表显示 */
    NSArray *_cityList;
    /** model的整理数据 */
    NSArray *_topLocationList;
    
    NSInteger _selectedTopLocationId;
    NSInteger _selectedLocationCatId;
}

- (NSInteger)selectedTopLocationId;
- (NSInteger)selectedLocationCatId;

- (void)onHideTableDropdown;
- (void)onSelectItemInTableDropdownWithIndex:(NSInteger)index;

@end

@implementation MZLPersonalizedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initInternal];
    self.title = @"目的地";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initCities];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_tableDropdown hide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

#define KEY_ANCHOR_LOCATION @"KEY_ANCHOR_LOCATION"
#define KEY_SELECTED_INDEX @"KEY_SELECTED_INDEX"

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:MZL_SEGUE_TOARTICLEDETAIL]) {
        MZLArticleDetailViewController *vc = segue.destinationViewController;
        MZLModelLocationBase *anchorLocation = [sender getProperty:KEY_ANCHOR_LOCATION];
        if (anchorLocation) {
            [sender removeProperty:KEY_ANCHOR_LOCATION];
            vc.targetLocation = anchorLocation;
        }
    }
    else if ([segue.identifier isEqualToString:MZL_SEGUE_TOLOCATIONDETAIL]) {
        MZLLocationDetailViewController *vc = segue.destinationViewController;
        NSNumber *value = [sender getProperty:KEY_SELECTED_INDEX];
        if (value) {
            [sender removeProperty:KEY_SELECTED_INDEX];
            vc.selectedIndex = [value integerValue];
        }
    }
}

- (void)toArticleDetail:(MZLModelArticle *)article anchorLocation:(MZLModelLocationBase *)location {
    [article setProperty:KEY_ANCHOR_LOCATION value:location];
    [self performSegueWithIdentifier:MZL_SEGUE_TOARTICLEDETAIL sender:article];
}

//- (void)toLocationDetail:(MZLModelLocationBase *)location selectedIndex:(NSInteger)selectedIndex {
//    [location setProperty:KEY_SELECTED_INDEX value:@(selectedIndex)];
//    [self performSegueWithIdentifier:MZL_SEGUE_TOLOCATIONDETAIL sender:location];
//}
//
//- (void)toLocationDetail:(MZLModelLocationBase *)location {
//    [self toLocationDetail:location selectedIndex:MZL_LOCATION_DETAIL_INFO_SECTION];
//}
//
//- (void)toLocationDetailArticles:(MZLModelLocationBase *)location {
//    [self toLocationDetail:location selectedIndex:MZL_LOCATION_DETAIL_ARTICLES_SECTION];
//}
//
//- (void)toLocationDetailLocations:(MZLModelLocationBase *)location {
//    [self toLocationDetail:location selectedIndex:MZL_LOCATION_DETAIL_LOCATIONS_SECTION];
//}

- (void)toExplore {
    MZLTabBarViewController *tabVc = (MZLTabBarViewController *)self.tabBarController;
    [tabVc toExploreTab];
}

#pragma mark - init

- (void)initInternal {
    [self initLocation];
    [self initUI];
}

- (void)initUI {
    _tv = self.tvPersonalized;
    _tv.backgroundColor = MZL_BG_COLOR();
    [self initTopView];
    [self addCityListDropdownBarButtonItem];
}

- (void)initLocation {
    [self mzl_registerUpdateLocation];
}

- (void)initCities {
    [self loadCityList];
}

#pragma mark - top view related

#define TEXT_ALL_CITIES @"全部城市"
#define TEXT_ALL_CAT @"全部分类"

#define TAG_TOP_LEFT_VIEW 1001
#define TAG_TOP_RIGHT_VIEW 1002

#define TAG_TOP_VIEW_LABLE 2000
#define TAG_TOP_VIEW_IMAGE 2001

- (void)initTopView {
    _topSectionViews = [NSMutableArray array];
    
    UIView *topLeftView = [self.vwTop createSubView];
    [topLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_equalTo(topLeftView.superview);
        make.width.mas_equalTo(self.view.width / 2.0);
    }];
    [self initTopSectionView:topLeftView tag:TAG_TOP_LEFT_VIEW];
    
    UIView *centerSepView = [self.vwTop createSubView];
    centerSepView.backgroundColor = colorWithHexString(@"#d8d8d8");
    [centerSepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(topLeftView.mas_right);
        make.top.bottom.mas_equalTo(centerSepView.superview);
        make.width.mas_equalTo(0.5);
    }];
    
    UIView *topRightView = [self.vwTop createSubView];
    [topRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(topRightView.superview);
        make.left.mas_equalTo(centerSepView.mas_right);
    }];
    [self initTopSectionView:topRightView tag:TAG_TOP_RIGHT_VIEW];
    
    UIView *bottomSep = [self.vwTop createSepView];
    bottomSep.backgroundColor = colorWithHexString(@"#d8d8d8");
    [bottomSep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottomSep.superview);
    }];
}

- (void)initTopSectionView:(UIView *)section tag:(NSInteger)tag {
    UIView *content = [section createSubView];
    [content addTapGestureRecognizer:self action:@selector(onTopSectionClicked:)];
    [_topSectionViews addObject:content];
    content.tag = tag;
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(content.superview);
        make.width.mas_equalTo(160);
        make.centerX.mas_equalTo(content.superview);
    }];
    UILabel *lbl = [content createSubViewLabelWithFontSize:12 textColor:colorWithHexString(@"#B0B0B0")];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(lbl.superview);
    }];
    lbl.tag = TAG_TOP_VIEW_LABLE;
    UIImageView *image = [content createSubViewImageViewWithImageNamed:@"Personalize_Top_Arrow"];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(8, 8));
        make.centerY.mas_equalTo(image.superview);
        make.left.mas_equalTo(lbl.mas_right).offset(6);
    }];
    image.tag = TAG_TOP_VIEW_IMAGE;
    
    if (tag == TAG_TOP_LEFT_VIEW) {
        lbl.text = TEXT_ALL_CITIES;
    } else {
        lbl.text = TEXT_ALL_CAT;
    }
}

- (void)resetTopSectionsUI {
    for (UIView *topSectionView in _topSectionViews) {
        UILabel *lbl = (UILabel *)[topSectionView viewWithTag:TAG_TOP_VIEW_LABLE];
        lbl.textColor = colorWithHexString(@"#B0B0B0");
        UIImageView *image = (UIImageView *)[topSectionView viewWithTag:TAG_TOP_VIEW_IMAGE];
        image.image = [UIImage imageNamed:@"Personalize_Top_Arrow"];
    }
}

- (void)resetTopSectionState {
    for (UIView *topSectionView in _topSectionViews) {
        UILabel *lbl = (UILabel *)[topSectionView viewWithTag:TAG_TOP_VIEW_LABLE];
        if (topSectionView.tag == TAG_TOP_LEFT_VIEW) {
            lbl.text = TEXT_ALL_CITIES;
        } else {
            lbl.text = TEXT_ALL_CAT;
        }
    }
    _selectedLocationCatId = 0;
    _selectedTopLocationId = 0;
}

- (void)onTopSectionClicked:(UITapGestureRecognizer *)tap {
    UIView *highlighted = tap.view;
    NSInteger typeTo = highlighted.tag == TAG_TOP_LEFT_VIEW ? TYPE_CITY : TYPE_CAT;
    if ([_tableDropdown isShown] && _tableDropdown.displayType == typeTo) {
        [_tableDropdown hide];
        return;
    }
    [self resetTopSectionsUI];
    UILabel *lbl = (UILabel *)[highlighted viewWithTag:TAG_TOP_VIEW_LABLE];
    lbl.textColor = colorWithHexString(@"#ffd521");
    UIImageView *image = (UIImageView *)[highlighted viewWithTag:TAG_TOP_VIEW_IMAGE];
    image.image = [UIImage imageNamed:@"Personalize_Top_Arrow_Hi"];
    if (! _tableDropdown) {
        _tableDropdown = [MZLTableDropdownView instance];
        _tableDropdown.vc = self;
    }
    if (highlighted.tag == TAG_TOP_LEFT_VIEW) {
        _tableDropdown.ds = _cityList;
    } else {
        _tableDropdown.ds = allLocationCategories();
    }
    _tableDropdown.displayType = typeTo;
    [_tableDropdown show];
}

- (void)onHideTableDropdown {
    [self resetTopSectionsUI];
}

- (void)onSelectItemInTableDropdownWithIndex:(NSInteger)index {
    if (_tableDropdown.displayType == TYPE_CITY) {
        NSString *locationName;
        if (index > 0) {
            MZLPersonalizedTopLocation *location = _cityList[index - 1];
            _selectedTopLocationId = location.identifier;
            locationName = location.name;
        } else {
            _selectedTopLocationId = 0;
            locationName = TEXT_ALL_CITIES;
        }
        UIView *leftView = _topSectionViews[0];
        UILabel *lbl = (UILabel *)[leftView viewWithTag:TAG_TOP_VIEW_LABLE];
        lbl.text = locationName;
    } else {
        _selectedLocationCatId = index;
        UIView *rightView = _topSectionViews[1];
        UILabel *lbl = (UILabel *)[rightView viewWithTag:TAG_TOP_VIEW_LABLE];
        lbl.text = allLocationCategories()[index];
    }
    [self loadModels];
}

#pragma mark - location related

- (void)_mzl_onLocationUpdated {
    [self onPersonalizedParamModified];
    [self loadModelsWhenViewIsVisible];
}

#pragma mark - override

- (void)onFilterOptionsModified {
    [self onPersonalizedParamModified];
    [super onFilterOptionsModified];
}

- (void)onFilterOptionsHidden {
    // Fix 在显示/隐藏statusBar时，statusBar高度没有计算在topLayoutGuide上
    [self.view setNeedsLayout];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (NSInteger)pageFetchCount {
    return 150;
}

- (BOOL)_canLoadMore {
    return NO;
}

- (void)_loadModelsWithFilters:(MZLFilterParam *)filter {
    [self loadModelsWithFilter:filter];
}

- (void)_loadModelsWithoutFilters {
    MZLFilterParam *param = [[MZLFilterParam alloc] init];
    [self loadModelsWithFilter:param];
}

- (void)loadModelsWithFilter:(MZLFilterParam *)filter {
    NSString *selectedCity = [MZLSharedData selectedCity];
    if (isEmptyString(selectedCity)) {
        [self hideProgressIndicator:NO];
        [self showCityListOnLocationNotDetermined];
        return;
    }
    MZLPersonalizeSvcParam *param = [MZLPersonalizeSvcParam instanceWithCurLocation:selectedCity topLocationId:_selectedTopLocationId categoryId:_selectedLocationCatId];
    [self invokeService:@selector(personalizeServiceWithParam:filter:succBlock:errorBlock:) params:@[param, filter]];
}

- (NSMutableArray *)mapModelsOnLoad:(NSArray *)modelsFromSvc {
    _topLocationList = [self handleTopLocations:modelsFromSvc];
    [self mergeCityListFromModelTopLocations];
    return [super mapModelsOnLoad:modelsFromSvc];
}

- (void)mzl_onWillBecomeTabVisibleController {
    [self loadModelsWhenViewIsVisible];
}

- (NSArray *)noRecordTextsWithFilters {
    return @[@"对不起啊，", @"没有找到符合你需求的目的地，", @"请重新选择。"];
}

- (CGFloat)footerSpacingViewHeight {
    return 5.0;
}

#pragma mark - service related

- (void)loadCityList {
    NSString *selectedCity = [MZLSharedData selectedCity];
    if (! isEmptyString(selectedCity)) {
        MZLFilterParam *filterParam = [MZLFilterParam filterParamsFromSelectedFilterOptions];
        __weak MZLPersonalizedViewController *weakSelf = self;
        [MZLServices cityPersonalizeServiceWithLocation:selectedCity filter:filterParam succBlock:^(NSArray *models) {
            [weakSelf rebuildCityList:models];
        } errorBlock:^(NSError *error) {
            // ignore
        }];
    }
}

- (void)rebuildCityList:(NSArray *)models {
    NSMutableArray *cityList = [NSMutableArray array];
    for (MZLModelLocationBase *locBase in models) {
        MZLPersonalizedTopLocation *location = [[MZLPersonalizedTopLocation alloc] init];
        location.identifier = locBase.identifier;
        location.name = locBase.name;
        location.pinyinString = [location.name co_toPinYin];//[COStringWithPinYin instanceFromString:location.name];
        [cityList addObject:location];
    }
    _cityList = [NSArray arrayWithArray:cityList];
    [self mergeCityListFromModelTopLocations];
}

- (void)mergeCityListFromModelTopLocations {
    for (MZLPersonalizedTopLocation *locFromCityList in _cityList) {
        BOOL matchedFlag = NO;
        for (MZLPersonalizedTopLocation *locFromTopLocList in _topLocationList) {
            if (locFromCityList.identifier == locFromTopLocList.identifier) {
                locFromCityList.childLocations = locFromTopLocList.childLocations;
                matchedFlag = YES;
                break;
            }
        }
        // 重设
        if (! matchedFlag) {
            locFromCityList.childLocations = nil;
        }
    }
    NSSortDescriptor *sortArticleCount = [[NSSortDescriptor alloc] initWithKey:@"articleCountFromAllChildLocations" ascending:NO];
    NSSortDescriptor *sortPinyin = [[NSSortDescriptor alloc] initWithKey:@"pinyinString" ascending:YES];
    _cityList = [_cityList sortedArrayUsingDescriptors:@[sortArticleCount, sortPinyin]];
}


- (MZLPersonalizedTopLocation *)findTopLocationForLocation:(MZLModelLocationDetail *)location topLocations:(NSArray *)topLocations {
    for (MZLPersonalizedTopLocation *topLocation in topLocations) {
        if ([location.topParentLocationName isEqualToString:topLocation.name]) {
            return topLocation;
        }
    }
    return nil;
}

- (NSMutableArray *)handleTopLocations:(NSArray *)modelsFromSvc {
    // 整理归并小目的地到大目的地
    NSMutableArray *topLocations = [NSMutableArray array];
    for (MZLModelLocationDetail *location in modelsFromSvc) {
        // 没有父级目的地，忽略
        if (isEmptyString(location.topParentLocationName)) {
            continue;
        }
        MZLPersonalizedTopLocation *topLocation = [self findTopLocationForLocation:location topLocations:topLocations];
        if (topLocation) {
            topLocation.childLocations = [topLocation.childLocations arrayByAddingObject:location];
        } else {
            topLocation = [[MZLPersonalizedTopLocation alloc] init];
            topLocation.name = location.topParentLocationName;
            topLocation.identifier = location.topParentLocationId;
            topLocation.childLocations = [NSArray arrayWithObject:location];
            [topLocations addObject:topLocation];
        }
    }
//    // 显示逻辑处理，第一次最多只显示5个子目的地
//    for (MZLPersonalizedTopLocation *topLocation in topLocations) {
//        topLocation.visibleChildLocationCount = topLocation.childLocations.count;
//        if (topLocation.visibleChildLocationCount > PER_CHILD_LOCATIONS) {
//            topLocation.visibleChildLocationCount = PER_CHILD_LOCATIONS + topLocation.childLocations.count / 4;
//        }
//    }
//    // 排序，拥有最多玩法的大目的地排前面
//    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"articleCountFromAllChildLocations" ascending:NO];
//    topLocations = [NSMutableArray arrayWithArray:[topLocations sortedArrayUsingDescriptors:@[descriptor]]];
    return topLocations;
}

- (NSInteger)selectedTopLocationId {
    return _selectedTopLocationId;
}

- (NSInteger)selectedLocationCatId {
    return _selectedLocationCatId;
}

- (void)onPersonalizedParamModified {
    [self resetTopSectionState];
    [self loadCityList];
}

#pragma mark - table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"MZLPersonalizedItemCell";
    MZLPersonalizedItemCell *cell = [tableView dequeueReusableTableViewCell:reuseIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MZLModelLocationDetail *location = _models[indexPath.row]; // [[_models[indexPath.section] childLocations] objectAtIndex:indexPath.row];
    cell.vc = self;
    cell.location = location;
//    cell.isLastCell = [self isLastCellForIndexPath:indexPath];
//    cell.isLastSection = [self isLastSection:indexPath.section];
//    cell.hasMore = [self hasMoreForSection:indexPath.section];
    [cell updateCell];
    return cell;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [MZLPersonalizedItemCell cellHeight];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLModelLocationDetail *location = _models[indexPath.row];
    [self toLocationDetailWithLocation:location];
}

@end

@implementation MZLPersonalizedTopLocation

- (NSInteger)articleCountFromAllChildLocations {
    NSInteger result = 0;
    for (MZLModelLocationDetail *child in self.childLocations) {
        result += child.totalArticleCount;
    }
    return result;
}

- (BOOL)hasMoreChildLocations {
    return self.visibleChildLocationCount < self.childLocations.count;
}

@end

@implementation MZLTableDropdownView

#define DROPDOWN_VIEW_Y (HEIGHT_TOP_SECTION + MZL_TOP_BAR_HEIGHT)
#define DROPDOWN_VIEW_HIDE_FRAME (CGRectMake(0, DROPDOWN_VIEW_Y, globalWindow().bounds.size.width, 0))
#define DROPDOWN_VIEW_SHOW_FRAME (CGRectMake(0, DROPDOWN_VIEW_Y, globalWindow().bounds.size.width, globalWindow().bounds.size.height - DROPDOWN_VIEW_Y))

+ (MZLTableDropdownView *)instance {
    MZLTableDropdownView *view = [[MZLTableDropdownView alloc] initWithFrame:DROPDOWN_VIEW_HIDE_FRAME];
    [view internalInit];
    return view;
}

- (BOOL)isShown {
    return self.superview != nil;
}

- (void)resetTablePos {
    _tv.contentOffset = CGPointMake(0, 0);
}

- (void)show {
    if (! self.superview) {
        self.frame = DROPDOWN_VIEW_SHOW_FRAME;
        [globalWindow() addSubview:self];
    } else {
        [self resetTablePos];
    }
    [UIView animateWithDuration:.3 animations:^{
        CGRect tvFrame = CGRectMake(0, 0, self.width, [self itemsCount] * _tv.rowHeight);
        if (tvFrame.size.height > self.height) {
            tvFrame.size.height = self.height;
        }
        _tv.frame = tvFrame;
        [_tv reloadData];
    } completion:^(BOOL finished) {
    }];
}

- (void)hide {
    if (! self.superview) {
        return;
    }
    self.frame = DROPDOWN_VIEW_HIDE_FRAME;
    [UIView animateWithDuration:.3 animations:^{
        // 高度跟self一样缩减为0
        _tv.frame = CGRectMake(0, 0, self.width, self.height);
    } completion:^(BOOL finished) {
        [self resetTablePos];
        [self.vc onHideTableDropdown];
        [self removeFromSuperview];
    }];
}

- (void)internalInit {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
    tv.rowHeight = 44;
    tv.separatorColor = colorWithHexString(@"#d8d8d8");
    tv.dataSource = self;
    tv.delegate = self;
    _tv = tv;
    tv.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 15)];
    [self addSubview:tv];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellReuseId = @"MZLTableDropdownCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId];
    if (! cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseId];
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        // Explictly set your cell's layout margins
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.separatorInset = UIEdgeInsetsZero;
        cell.textLabel.font = MZL_FONT(12);
        cell.textLabel.textColor = colorWithHexString(@"#434343");
    }
    cell.imageView.image = nil;
    cell.textLabel.textColor = colorWithHexString(@"#434343");
    if (self.displayType == TYPE_CAT) {
        cell.textLabel.text = self.ds[indexPath.row];
        cell.imageView.image = [[UIImage imageNamed:allLocationCatImages()[indexPath.row]] scaledToSize:CGSizeMake(18, 18)];
    } else {
        BOOL isSelectedCity = NO;
        if (indexPath.row == 0) {
            cell.textLabel.text = TEXT_ALL_CITIES;
            isSelectedCity = (self.vc.selectedTopLocationId == 0);
        } else {
            MZLPersonalizedTopLocation *location = self.ds[indexPath.row - 1];
            cell.textLabel.text = location.name; //[NSString stringWithFormat:@"%@(%@)%@", location.name, @(location.articleCountFromAllChildLocations), location.pinyinString];
            isSelectedCity = (location.identifier == self.vc.selectedTopLocationId);
        }
        if (isSelectedCity) {
            cell.textLabel.textColor = colorWithHexString(@"#ffd521");
            cell.imageView.image = [[UIImage imageNamed:@"Personalize_Loc"] scaledToSize:CGSizeMake(12, 12)];
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)itemsCount {
    if (self.displayType == TYPE_CITY) {
        return self.ds.count + 1;
    }
    return self.ds.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self itemsCount];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
    [self.vc onSelectItemInTableDropdownWithIndex:indexPath.row];
}

@end
