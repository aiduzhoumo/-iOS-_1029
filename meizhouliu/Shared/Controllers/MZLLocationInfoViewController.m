//
//  MZLLocationInfoViewController.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-2-5.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLLocationInfoViewController.h"
#import "UIView+MZLAdditions.h"
#import "MZLModelLocationDetail.h"
#import "MZLModelLocationExt.h"
#import "MZLModelTagType.h"
#import <MapKit/MapKit.h>
#import "MZLMapAnnotation.h"
#import "MZLLocationMapViewController.h"
#import "UILabel+COAdditions.h"

#define H_MARGIN_FOR_CONTENT_TOP 16.0
#define SEGUE_TO_MAP @"toMap"


@interface MZLLocationInfoViewController () <MKMapViewDelegate> {
    __weak UIView *_content;
    __weak MKMapView *_map;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@end

@implementation MZLLocationInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initInternal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:SEGUE_TO_MAP]) {
        MZLLocationMapViewController *vcMap = segue.destinationViewController;
        vcMap.location = _locationDetail;
    }
}

#pragma mark - init

- (void)initInternal {
    [self initUI];
}

- (void)initUI {
    UIView *contentView = [self.scroll createSubView];
    _content = contentView;
    [contentView co_insetsParent:UIEdgeInsetsMake(0, 0, 0, 0) width:CO_SCREEN_WIDTH height:COInvalidCons];

    [self initContentTop];
//    [self initContentBottom];
}

#pragma mark - tags and info view

- (void)initContentTop {
    CGFloat vMargin = 14.0;
    UIView *contentTop = [[_content createSubView] co_insetsParent:UIEdgeInsetsMake(vMargin, H_MARGIN_FOR_CONTENT_TOP, vMargin, H_MARGIN_FOR_CONTENT_TOP)];
    [self initTagsViewWithParent:contentTop];
    [self initInfoViewWithParent:contentTop];
}

- (void)initTagsViewWithParent:(UIView *)parent {
    UIView *tagsView = [[parent createSubView] co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, 0)];

    for (MZLModelTagType *tagType in self.locationDetail.tagTypes) {
        [self tagViewWithParent:tagsView tagType:tagType];
    }
    if (self.locationDetail.averageConsumption > 0) {
        NSInteger consumption = (NSInteger)self.locationDetail.averageConsumption;
        [self viewWithParent:tagsView leftText:@"花费" rightText:INT_TO_STR(consumption)];
    }
    
    if (tagsView.subviews.count == 0) {
        [tagsView co_height:0];
    } else {
        UIView *lastSubview = [[tagsView subviews] lastObject];
        [lastSubview co_bottomParent:14.0];
    }
    
    [tagsView createBottomSepView];
}

- (UIView *)tagViewWithParent:(UIView *)parent tagType:(MZLModelTagType *)tagType {
    NSString *tagTypeName = tagType.name;
    NSArray *tags = [tagType.tags componentsSeparatedByString:@" "];
    NSString *tagsStr = [tags componentsJoinedByString:@"，"];
    return [self viewWithParent:parent leftText:tagTypeName rightText:tagsStr];
}

- (UIView *)viewWithParent:(UIView *)parent leftText:(NSString *)leftText rightText:(NSString *)rightText {
    UIView *view = [parent createSubView];
    
    UILabel *lblLeft = [view createSubViewLabelWithFont:MZL_BOLD_FONT(12) textColor:@"434343".co_toHexColor];
    lblLeft.text = leftText;
    [lblLeft sizeToFit];
    CGFloat lblFittingWidth = lblLeft.width;
    [lblLeft co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, COInvalidCons) width:lblFittingWidth height:COInvalidCons];
    
    CGFloat hSpace = 8.0;
    UILabel *lblRight = [view createSubViewLabelWithFontSize:12 textColor:@"888888".co_toHexColor];
    lblRight.numberOfLines = 0;
    lblRight.text = rightText;
    [lblRight co_setLineSpacing:3];
    lblRight.textAlignment = NSTextAlignmentLeft;
    CGFloat preferredMaxLayoutWidth = CO_SCREEN_WIDTH - 2 * H_MARGIN_FOR_CONTENT_TOP - hSpace - lblFittingWidth;
    lblRight.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
    [lblRight co_insetsParent:UIEdgeInsetsMake(0, COInvalidCons, 0, 0)];
    [lblRight co_leftFromRightOfView:lblLeft offset:hSpace];
    
    [view co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, COInvalidCons, 0)];
    UIView *preView = [view co_preSiblingView];
    if (preView) {
        [view co_topFromBottomOfView:preView offset:6];
    } else {
        [view co_topParent];
    }
    
    return view;
}

- (void)initInfoViewWithParent:(UIView *)parent {
    // 定ContentTop下边距
    UIView *infoView = [[parent createSubView] co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, 0, 0)];
    UIView *preView = [infoView co_preSiblingView];
    if (preView) {
        [infoView co_topFromBottomOfView:preView offset:0];
    } else {
        [infoView co_topParent];
    }
    NSString *locIntro = self.locationDetail.locationExt.introduction;
    UILabel *lbl;
    if (isEmptyString(locIntro)) {
        [infoView co_height:0];
    } else {
        lbl = [infoView createSubViewLabelWithFontSize:14 textColor:@"888888".co_toHexColor];
        lbl.numberOfLines = 0;
        lbl.text = locIntro;
        [lbl co_setLineSpacing:6];
        [lbl co_insetsParent:UIEdgeInsetsMake(16, 0, 16, 0)];
    }
    
//    lbl.backgroundColor = [UIColor orangeColor];
//    infoView.backgroundColor = [UIColor purpleColor];
}

#pragma mark - map view


- (void)initContentBottom {
    UIView *contentBottom = [[_content createSubView] co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, 0, 0)];
    UIView *preView = [contentBottom co_preSiblingView];
    [contentBottom co_topFromBottomOfView:preView offset:0];
    
    [self initMapViewWithParent:contentBottom];
    
    [contentBottom co_heightZeroIfNoSubviews];
}

- (void)initMapViewWithParent:(UIView *)parent {
    if (! isLocationCoordinateValid(self.locationDetail)) {
        return;
    }
    
    MKMapView *map = [[MKMapView alloc] init];
    [parent addSubview:map];
    map.delegate = self;
    [[map co_withinParent] co_height:200];
    
    _map = map;
    map.scrollEnabled = NO;
    map.zoomEnabled = NO;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.locationDetail.latitude;
    coordinate.longitude = self.locationDetail.longitude;
    MKCoordinateSpan coordinateSpan = coordinateSpanFromLocation(self.locationDetail);
    MKCoordinateRegion regin = {coordinate, coordinateSpan};
    [map setRegion:regin animated:NO];
    MZLMapAnnotation *annotation = [[MZLMapAnnotation alloc] initWithLocation:coordinate title:self.locationDetail.name subTitle:nil];
    annotation.displayName = self.locationDetail.address;
    [map addAnnotation:annotation];
    [map addTapGestureRecognizer:self action:@selector(toMap)];
    
    // map address
    if (! isEmptyString(self.locationDetail.address)) {
        UIView *addressView = [[parent createSubView] co_insetsParent:UIEdgeInsetsMake(COInvalidCons, 0, 0, 0) width:COInvalidCons height:32];
        addressView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        UILabel *addressLbl = [addressView createSubViewLabelWithFontSize:12 textColor:@"D8D8D8".co_toHexColor];
        addressLbl.text = self.locationDetail.address;
        addressLbl.numberOfLines = 2;
        CGFloat margin = 16.0;
        addressLbl.preferredMaxLayoutWidth = self.view.width - 2 * margin;
        [addressLbl co_insetsParent:UIEdgeInsetsMake(COInvalidCons, margin, COInvalidCons, COInvalidCons)];
        [addressLbl co_centerYParent];
    }
}

- (void)toMap {
    [self performSegueWithIdentifier:@"toMap" sender:nil];
}

#pragma mark - map view delegate


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString * const identifier = @"PinView";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (pinView) {
        pinView.annotation = annotation;
    } else {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    pinView.canShowCallout = NO;
    return pinView;
}

@end
