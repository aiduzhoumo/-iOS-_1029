//
//  MZLArticleDetailPOINavVwController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-7-22.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLArticleDetailPOINavVwController.h"
#import "MZLRouteAnnotation.h"
#import "MZLLocationRouteInfo.h"
#import "UIViewController+MZLAnnotationView.h"
#import "MZLArticleDetailNavVwController.h"
#import "UIViewController+MZLModelPresentation.h"
#import "MZLArticleDetailViewController.h"

@interface MZLArticleDetailPOINavVwController () {
    NSMutableArray *_annotations;
    MZLLocationRouteInfo *_selected;
    __weak MKAnnotationView *_selectedView;
    
    BOOL _isFirstAddAnnotationViews;
}

@end

@implementation MZLArticleDetailPOINavVwController

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
    self.title = @"导航";
    self.map.delegate = self;
    [self.map addAnnotations:_annotations];
    _isFirstAddAnnotationViews = YES;
    [self initWithStatusBar:self.bgStatusBar navBar:self.navBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BOOL isDisplayAllLocations = NO;
    MZLModelLocationBase *centerLocation = _selected.location;
    // 需要检查经纬度是否有效
    if (! centerLocation || ! isCoordinateValid(CLLocationCoordinate2DMake(centerLocation.latitude, centerLocation.longitude))) {
        MZLRouteAnnotation *routeAnnotation = _annotations[0];
        centerLocation = routeAnnotation.routeInfo.location;
        isDisplayAllLocations = YES;
    }
    NSArray *locations = [_annotations map:^id(id object) {
        return ((MZLRouteAnnotation *)object).routeInfo.location;
    }];
    MKCoordinateSpan span = coordinateSpanAmongLocations(centerLocation, locations, MZL_MAP_ZOOM_SCALE_ARTICLEDETAIL_NAV_POI, isDisplayAllLocations);
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(centerLocation.latitude, centerLocation.longitude), span);
    [self.map setRegion:region animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)setAnnotations:(NSArray *)annotations {
    _annotations = [NSMutableArray array];
    for (MZLRouteAnnotation *annotation in annotations) {
        MZLRouteAnnotation *temp = [[MZLRouteAnnotation alloc] init];
        temp.routeInfo = annotation.routeInfo;
        temp.coordinate = annotation.coordinate;
        temp.title = annotation.routeInfo.location.name;
//        temp.subtitle = annotation.routeInfo.location.address;
        [_annotations addObject:temp];
    }
}

- (void)setSelectedLocation:(MZLLocationRouteInfo *)location {
    _selected = location;
}

#pragma mark - map view delegate

#define PROPERTY_ANNOTATION @"PROPERTY_ANNOTATION"


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if (_selectedView) {
        [self setAnnotationViewSelected:_selectedView flag:NO];
    }
    [self setAnnotationViewSelected:view flag:YES];
    MZLRouteAnnotation *annotation = (MZLRouteAnnotation *)view.annotation;
    [self setSelectedLocation:annotation.routeInfo];
//    self.articleDetailVwCtrl.targetLocation = annotation.routeInfo.location;
    self.articleCtrl.targetLocationRouteInfo = annotation.routeInfo;
    _selectedView = view;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
//    [self setAnnotationViewSelected:view flag:NO];
    if (_selectedView) {
        [_selectedView.superview bringSubviewToFront:_selectedView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MZLRouteAnnotation *routeAnnotation = (MZLRouteAnnotation *)annotation;
    BOOL isSelected = (routeAnnotation.routeInfo == _selected);
    MKAnnotationView *result = [self bubbleAnnotationForMapView:mapView withAnnotation:routeAnnotation isSelected:isSelected];
    if (isSelected) {
        _selectedView = result;
    }
    result.rightCalloutAccessoryView = [self navCalloutViewForAnnotation:routeAnnotation];
    result.canShowCallout = YES;
    return result;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    if (_selectedView) {
        if (_isFirstAddAnnotationViews) {
            [self.map selectAnnotation:_selectedView.annotation animated:YES];
            _isFirstAddAnnotationViews = NO;
        } else {
            [_selectedView.superview bringSubviewToFront:_selectedView];
        }
    }
}

- (void)mzl_pushViewController:(UIViewController *)vc {
    if ([self.presentingViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *presentingVc = (UITabBarController *)self.presentingViewController;
        [self dismissViewControllerAnimated:YES completion:^{
            UINavigationController *navVc = (UINavigationController *)presentingVc.selectedViewController;
            MZLArticleDetailViewController * articleDetailVc = (MZLArticleDetailViewController *)navVc.visibleViewController;
            [articleDetailVc mzl_pushViewController:vc];
        }];
    }
}

@end
