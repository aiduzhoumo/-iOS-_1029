//
//  MZLArticleDetailNavVwController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-12.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLArticleDetailNavVwController.h"
#import "MZLArticleDetailViewController.h"
#import "MZLRouteCell.h"
#import "UITableView+MZLAdditions.h"
#import "WeView.h"
#import "UILabel+COAdditions.h"
#import "MZLSelectedRouteCell.h"
#import "MZLRouteAnnotation.h"
#import "MZLLocationRouteInfo.h"
#import "MZLModelArticleDetail.h"
#import "MZLModelRouteInfo.h"
#import "MZLModelLocation.h"
#import "MZLModelUserLocationPref.h"
#import "MobClick.h"
#import "UIViewController+MZLAnnotationView.h"

#define HEIGHT_SECTION_HEADER 20.0

@interface MZLArticleDetailNavVwController () {
    NSMutableArray *_routesInfo;
    /** 其中的每个元素是一个包含MZLLocationRouteInfo的数组，代表某一天的行程 */
    NSMutableArray *_routesInfoByDay;
    NSMutableArray *_annotations;
    MZLLocationRouteInfo *_selected;
}

@end

@implementation MZLArticleDetailNavVwController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initInternal];
    
    self.tv.backgroundColor = [UIColor clearColor];
    [self.tv removeUnnecessarySeparators];
    
    self.lblCity.textColor = MZL_COLOR_GREEN_61BAB3();
    self.lblCity.font = MZL_BOLD_FONT(20.0);
    for (UILabel *lbl in @[self.lblRoute, self.lblCurLoc]) {
        lbl.textColor = colorWithHexString(@"#555555");
        lbl.font = MZL_BOLD_FONT(12.0);
    }
    self.lblCity.text = self.article.destination.name;
    
    UIColor *bgColor = colorWithHexString(@"#dcf1ee");
    self.vwContentLeft.layer.cornerRadius = 3.0;
    self.vwContentLeft.backgroundColor = bgColor;
    self.vwContent.backgroundColor = bgColor;
    
    [self.map addTapGestureRecognizer:self action:@selector(clickMapView)];
    [self.vwBackArrow addTapGestureRecognizer:self action:@selector(vwBackArrowTohideWithAnimation)];
    [self.vwLocation addTapGestureRecognizer:self action:@selector(toLocationDetail)];
    
    UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(onSwipeRight)];
    sgr.direction = UISwipeGestureRecognizerDirectionRight;
    [self.bgView addGestureRecognizer:sgr];

    CGFloat screenHeight = CO_SCREEN_HEIGHT;
    CGFloat minScreenHeight = MZL_BASE_SCREEN_HEIGHT;
    CGFloat minArrowHeight = 37.0;
    CGFloat minArrowBottom = 39.0;
    self.vwArrowHeight.constant = round(screenHeight * minArrowHeight / minScreenHeight);
    self.vwArrowMarginBottom.constant = round(screenHeight * minArrowBottom / minScreenHeight);
    
    if (co_isIPhone6PlusScreen()) {
        self.vwArrowHeight.constant += 13.0;
        self.vwArrowMarginBottom.constant += 2.0;
    } else if (co_isIPhone6Screen()) {
        self.vwArrowHeight.constant += 10.0;
        self.vwArrowMarginBottom.constant += 2.0;
    } else {
        self.vwArrowHeight.constant += 6.0;
    }
}

- (void)clickMapView {
    [MobClick event:@"clickArticleDetailSideBarMap"];
    if (_annotations.count == 0) { // 地图上没有点，不跳转导航界面
        return;
    }
    [self toPOINav];
}

- (void)toLocationDetail {
    if (self.article) {
        [self toLocationDetail:self.article.destination];
        [MobClick event:@"clickArticleDetailSideBarLocationTop"];
    }
}

- (void)toPOINav {
    UIViewController *parentViewController = self.parentViewController;
    [parentViewController performSegueWithIdentifier:MZL_SEGUE_TOPOINAV sender:nil];
//    [self hideWithAnimation:^{
//        [parentViewController performSegueWithIdentifier:MZL_SEGUE_TOPOINAV sender:nil];
//    }];
}

- (void)toLocationDetail:(MZLModelLocationBase *)location {
    UIViewController *parentViewController = self.parentViewController;
    [self hideWithAnimation:^{
        [parentViewController performSegueWithIdentifier:MZL_SEGUE_TOLOCATIONDETAIL sender:location];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self onLocationSelected:self.targetLocationRouteInfo];
    self.targetLocationRouteInfo = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MobClick beginLogPageView:@"文章详情侧边栏"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"文章详情侧边栏"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - hide

- (void)onSwipeRight {
    [self hideWithAnimation];
    [MobClick event:@"swapArticleDetailSidebarClose"];
    [MobClick event:@"globalSwapRight"];
}

- (void)vwBackArrowTohideWithAnimation {
    [self hideWithAnimation];
    [MobClick event:@"clickArticleDetailSidebarClose"];
}

- (void)hideWithAnimation {
    [self hideWithAnimation:nil];
}

- (void)hideWithAnimation:(void (^)(void))animationFinishedBlock {
    [self willMoveToParentViewController:nil];
    CGRect newFrame = self.view.frame;
    newFrame.origin.x = CO_SCREEN_WIDTH;
    [UIView animateWithDuration:MZL_ANIMATION_DURATION_DEFAULT
                     animations:^{
                         self.view.frame = newFrame;
                     }
                     completion:^(BOOL finished) {
                         MZLArticleDetailViewController *parent = (MZLArticleDetailViewController *)self.parentViewController;
                         [parent onChildViewDisappeared];
                         //Remove the old Detail Controller view from superview
                         [self.view removeFromSuperview];
                         //Remove the old Detail controller from the hierarchy
                         [self removeFromParentViewController];
                         if (animationFinishedBlock) {
                             animationFinishedBlock();
                         }
                     }];
}

#pragma mark - init route and annotation

- (void)initInternal {
    if (self.article) {
        [self initAnnotation];
    }
}

- (void)setArticle:(MZLModelArticleDetail *)article {
    if (article) {
        _article = article;
        [self initRouteInfo];
    }
}

- (void)initRouteInfo {
    _routesInfo = [NSMutableArray array];
    NSInteger tripCount = self.article.trips.count;
    _routesInfoByDay = [NSMutableArray arrayWithCapacity:tripCount];
    NSInteger index = 1;
    for (int i = 0; i < tripCount; i ++) {
        MZLModelRouteInfo *routeInfo = self.article.trips[i];
        NSMutableArray *routesInDay = [NSMutableArray array];
        for (int j = 0; j < routeInfo.destinations.count; j ++) {
            MZLModelLocationBase *locBase = routeInfo.destinations[j];
            MZLLocationRouteInfo *locRouteInfo = [[MZLLocationRouteInfo alloc]init];
            locRouteInfo.days = (i + 1);
            locRouteInfo.daysRouteIndex = (j + 1);
            locRouteInfo.index = index ++;
            locRouteInfo.location = locBase;
            [_routesInfo addObject:locRouteInfo];
            [routesInDay addObject:locRouteInfo];
        }
        [_routesInfoByDay addObject:routesInDay];
    }
}

- (void)initAnnotation {
    _annotations = [NSMutableArray array];
    for (MZLLocationRouteInfo *locRouteInfo in _routesInfo) {
        // 经纬度为0,0的点不在地图上显示
        if (locRouteInfo.location.latitude == 0 && locRouteInfo.location.longitude == 0) {
            continue;
        }
        MZLRouteAnnotation *annotation = [[MZLRouteAnnotation alloc] init];
        annotation.routeInfo = locRouteInfo;
        annotation.coordinate = CLLocationCoordinate2DMake(locRouteInfo.location.latitude, locRouteInfo.location.longitude);
        [self.map addAnnotation:annotation];
        [_annotations addObject:annotation];
    }
}

#pragma mark - user favored location

- (void)addArticleFavoredLocation:(MZLModelUserLocationPref *)userlocPref {
    [self.favoredLocations addObject:userlocPref];
}

- (void)removeArticleFavoredLocation:(MZLModelUserLocationPref *)userlocPref {
    [self.favoredLocations removeObject:userlocPref];
}

#pragma mark - table view data related

- (MZLModelLocationBase *)locationFromIndexPath:(NSIndexPath *)indexPath {
    MZLLocationRouteInfo *temp = [self locRouteInfoFromIndexPath:indexPath];
    return temp.location;
}

- (MZLLocationRouteInfo *)locRouteInfoFromIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = _routesInfoByDay[indexPath.section];
    return array[indexPath.row];
}

- (MZLLocationRouteInfo *)locRouteInfoFromIndex:(NSInteger)index {
    return _routesInfo[index - 1];
}


- (NSInteger)indexFromIndexPath:(NSIndexPath *)indexPath {
    MZLLocationRouteInfo *locRouteInfo = [self locRouteInfoFromIndexPath:indexPath];
    return locRouteInfo.index;
}

- (BOOL)isRowSelected:(MZLLocationRouteInfo *)locRouteInfo {
    if (_selected == locRouteInfo) {
        return YES;
    }
    return NO;
}

- (BOOL)isRowSelectedForIndexPath:(NSIndexPath *)indexPath {
    MZLLocationRouteInfo *temp = [self locRouteInfoFromIndexPath:indexPath];
    return [self isRowSelected:temp];
}

- (MZLModelUserLocationPref *)userLocPrefFromLocation:(MZLModelLocationBase *)loc {
    for (MZLModelUserLocationPref *userLocPref in self.favoredLocations) {
        if (userLocPref.locationId == loc.identifier) {
            return userLocPref;
        }
    }
    return nil;
}

- (void)setLocationInfo:(MZLModelLocationBase *)location withRouteCell:(MZLRouteCell *)cell {
    cell.lblLocation.text = location.name;
    cell.lblAddress.text = isEmptyString(location.address) ? MZL_MSG_DEFAULT_ADDRESS : location.address;
}

#pragma mark - table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WeView *view = [[WeView alloc]initWithFrame:CGRectMake(0.0, 0.0, tableView.width, HEIGHT_SECTION_HEADER)];
    UILabel *lbl = [[UILabel alloc]init];
    lbl.textColor = colorWithHexString(@"#aaaaaa");
    lbl.font = MZL_FONT(11.0);
    lbl.hasCellHAlign = YES;
    lbl.text = [NSString stringWithFormat:@"第%@天", @(section + 1)];
    [[[[view addSubviewsWithVerticalLayout:@[lbl]]
      setRightMargin:0.0]
     setHAlign:H_ALIGN_RIGHT]
     setTopMargin:0.0];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLLocationRouteInfo *locationRouteInfo = [self locRouteInfoFromIndexPath:indexPath];
    MZLModelLocationBase *location = locationRouteInfo.location;
    MZLRouteCell *cell;
    if ([self isRowSelected:locationRouteInfo]) {
        MZLSelectedRouteCell *selecteCell = [self.tv dequeueReusableTableViewCell:@"MZLSelectedRouteCell"];
        selecteCell.ownerController = self;
        selecteCell.userLocPref = [self userLocPrefFromLocation:location];
        selecteCell.location = location;
        selecteCell.lblPlay.text = INT_TO_STR(location.totalArticleCount);
        cell = selecteCell;
    } else {
        cell = [self.tv dequeueReusableTableViewCell:@"MZLRouteCell"];
    }
    cell.vwLineTop.hidden = NO;
    cell.vwLineBottom.hidden = NO;
    cell.lblIndex.text = INT_TO_STR([self indexFromIndexPath:indexPath]);
    [self setLocationInfo:location withRouteCell:cell];
    if (indexPath.row == 0) {
        cell.vwLineTop.hidden = YES;
    }
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        cell.vwLineBottom.hidden = YES;
    }
    [cell adjustLayout];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _routesInfoByDay.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *temp = _routesInfoByDay[section];
    return temp.count;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isRowSelectedForIndexPath:indexPath]) {
        return HEIGHT_SELECTED_ROUTE_CELL;
    } else {
        return HEIGHT_ROUTE_CELL;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isRowSelectedForIndexPath:indexPath]) {
        MZLModelLocationBase *location = [self locationFromIndexPath:indexPath];
        MZLSelectedRouteCell *cell = [self.tv dequeueReusableTableViewCell:@"MZLSelectedRouteCell"];
        [self setLocationInfo:location withRouteCell:cell];
        return [cell fitHeight];
    } else {
        return HEIGHT_ROUTE_CELL;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEIGHT_SECTION_HEADER;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MobClick event:@"clickArticleDetailSidebarPOI"];
    MZLLocationRouteInfo *routeInfo = [self locRouteInfoFromIndexPath:indexPath];
    [self onLocationSelected:routeInfo];
}

#pragma mark - map view data related

- (NSIndexPath *)indexPathFromIndex:(NSInteger)index {
    MZLLocationRouteInfo *temp = _routesInfo[index - 1];
    return [NSIndexPath indexPathForRow:temp.daysRouteIndex - 1 inSection:temp.days - 1];;
}

#pragma mark - map view misc

- (void)targetPointInMapView:(MZLRouteAnnotation *)annotation animated:(BOOL)animated isMax:(BOOL)isMax {
    NSArray *locations = [_routesInfo map:^id(id object) {
        return ((MZLLocationRouteInfo *)object).location;
    }];
    MKCoordinateSpan span = coordinateSpanAmongLocations(annotation.routeInfo.location, locations, MZL_MAP_ZOOM_SCALE_ARTICLEDETAIL_POI, isMax);
    MKCoordinateRegion region = MKCoordinateRegionMake(annotation.coordinate, span);
    [self.map setRegion:region animated:animated];
}

#pragma mark - map view delegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MZLRouteAnnotation *routeAnnotation = (MZLRouteAnnotation *)annotation;
    BOOL isSelected = routeAnnotation.routeInfo == _selected;
    MKAnnotationView *result = [self bubbleAnnotationForMapView:mapView withAnnotation:routeAnnotation isSelected:isSelected];
    
    result.canShowCallout = NO;
    return result;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    for (MZLRouteAnnotation *annotation in [mapView annotationsInMapRect:[mapView visibleMapRect]]) {
        if (annotation.routeInfo == _selected) {
            MKAnnotationView *view = [mapView viewForAnnotation:annotation];
            // 延时，如果不加延时，同一经纬度的多个POI可能无法正常显示
            dispatch_async(dispatch_get_main_queue(), ^{
                [view.superview bringSubviewToFront:view];
            });
            break;
        }
    }
}


//- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {}

#pragma mark - misc

- (void)onLocationSelected:(MZLLocationRouteInfo *)routeInfo {
    if (_selected) {
        [self deselectLocation:_selected];
    }
    _selected = routeInfo;
    [self selectLocation:routeInfo];
    
    [self.tv reloadData];

}

- (void)deselectLocation:(MZLLocationRouteInfo *)routeInfo {
    [self toggleLocationSelected:routeInfo flag:NO];
}

- (void)selectLocation:(MZLLocationRouteInfo *)routeInfo {
    if (! routeInfo) { // 取消选中，tableview和地图拉回到第一个
        if (_routesInfo.count > 0) {
            [self.tv scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        if (_annotations.count > 0) {
            [self targetPointInMapView:_annotations[0] animated:NO isMax:YES];
        }
        return;
    }
    [self toggleLocationSelected:routeInfo flag:YES];
}

- (MZLRouteAnnotation *)annotationFromRouteInfo:(MZLLocationRouteInfo *)routeInfo {
    for (MZLRouteAnnotation *annotation in _annotations) {
        if (annotation.routeInfo == routeInfo) {
            return annotation;
        }
    }
    return nil;
}

- (void)toggleLocationSelected:(MZLLocationRouteInfo *)routeInfo flag:(BOOL)flag {
    MZLRouteAnnotation *annotation = [self annotationFromRouteInfo:routeInfo];
    // 选中状态，需要定位地图，tableview位置以及与parentVC联动
    if (flag) {
        if (annotation) {
            [self targetPointInMapView:annotation animated:YES isMax:NO];
        }
        NSIndexPath *indexPath = [self indexPathFromIndex:routeInfo.index];
        dispatch_after(0.5, dispatch_get_main_queue(), ^{
            [self.tv scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            MZLArticleDetailViewController *parent = (MZLArticleDetailViewController *)self.parentViewController;
            if (self.ignoreParentScroll) {
                self.ignoreParentScroll = NO;
            } else {
                [parent scrollToLocationHeader:routeInfo];
            }
        });
    }
    if (annotation) {
        // 更新地图的bubble image。应该先定位地图，因为如果annotationView没有在地图中显示，viewForAnnoation是得不到的
        MKAnnotationView *annotationView = [self.map viewForAnnotation:annotation];
        [self setAnnotationViewSelected:annotationView flag:flag];
    }
}

- (NSArray *)getAnnotations {
    return _annotations;
}

- (MZLLocationRouteInfo *)getSelectedLocation {
    return _selected;
}

@end
