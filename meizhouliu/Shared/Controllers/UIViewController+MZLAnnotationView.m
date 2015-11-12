//
//  UIViewController+MZLAnnotationView.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-7-22.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIViewController+MZLAnnotationView.h"
#import "MZLLocationRouteInfo.h"
#import "MZLModelLocationBase.h"
#import <MapKit/MapKit.h>
#import "UIImage+COAdditions.h"
#import "MZLRouteAnnotation.h"
#import "MZLMapAnnotation.h"

@implementation UIViewController (MZLAnnotationView)

#define TAG_MAP_LABLE_INDEX 101

- (MKAnnotationView *)bubbleAnnotationForMapView:(MKMapView *)mapView withAnnotation:(MZLRouteAnnotation *)routeAnnotation isSelected:(BOOL)selected {
    
    static NSString * const identifier = @"BubbleView";
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView) {
        annotationView.annotation = routeAnnotation;
    } else {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:routeAnnotation
                                                      reuseIdentifier:identifier];
    }
    
    UILabel *lbl = (UILabel *)[annotationView viewWithTag:TAG_MAP_LABLE_INDEX];
    if (lbl) {
        [lbl removeFromSuperview];
    }
    if (routeAnnotation.index >= 10) {
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(4, 1, 20, 20)];
    } else {
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(7, 1, 20, 20)];
    }
    lbl.textColor = [UIColor whiteColor];
    lbl.font = MZL_BOLD_FONT(14.0);
    lbl.tag = TAG_MAP_LABLE_INDEX;
    lbl.text = [NSString stringWithFormat:@"%@", @(routeAnnotation.index)];
    [annotationView addSubview:lbl];

    [self setAnnotationViewSelected:annotationView flag:selected];
    
    return annotationView;
}

- (void)setAnnotationViewSelected:(MKAnnotationView *)annotationView flag:(BOOL)flag {
    annotationView.image = [self bubbleImage:flag];
    if (flag) {
        [annotationView.superview bringSubviewToFront:annotationView];
    }
}

- (UIImage *)bubbleImage:(BOOL)isSelected {
    CGSize imageSize = CGSizeMake(23.0, 30.0);
    if (isSelected) {
        UIImage *image = [UIImage imageNamed:@"AD_Cover_HBubble"] ;
        return [UIImage imageWithImage:image scaledToSize:imageSize];
    } else {
        UIImage *image = [UIImage imageNamed:@"AD_Cover_Bubble"] ;
        return [UIImage imageWithImage:image scaledToSize:imageSize];
    }
}

#pragma mark - navigation callout view

#define PROPERTY_ANNOTATION @"PROPERTY_ANNOTATION"

- (UIView *)navCalloutViewForAnnotation:(id<MKAnnotation>)annotation {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
    [rightButton setImage:[UIImage imageNamed:@"Map_Nav"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(navWithSystemMap:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setProperty:PROPERTY_ANNOTATION value:annotation];
    return rightButton;
}

- (void)navWithSystemMap:(id)sender {
    id<MKAnnotation> annotation = [sender getProperty:PROPERTY_ANNOTATION];

    CLLocationCoordinate2D coordinate = annotation.coordinate;
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                   addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    NSString *mapDisplayName;
    if ([annotation isKindOfClass:[MZLMapAnnotation class]]) {
        mapDisplayName = ((MZLMapAnnotation *)annotation).displayName;
    } else if ([annotation isKindOfClass:[MZLRouteAnnotation class]]) {
        mapDisplayName = ((MZLRouteAnnotation *)annotation).routeInfo.location.address;
    }
    if (isEmptyString(mapDisplayName)) {
        mapDisplayName = annotation.title;
    }
    [mapItem setName:mapDisplayName];
    
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    // Get the "Current User Location" MKMapItem
    MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
    // Pass the current location and destination map items to the Maps app
    [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                   launchOptions:launchOptions];
    
//    CLLocationCoordinate2D coordinate = annotation.coordinate;
//    NSString *appleLink2 = [NSString stringWithFormat:@"http://maps.apple.com/maps?q=%f,%f",coordinate.latitude, coordinate.longitude];
//    NSURL *myUrl = [NSURL URLWithString:[appleLink2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    [[UIApplication sharedApplication] openURL:myUrl];
}

@end
