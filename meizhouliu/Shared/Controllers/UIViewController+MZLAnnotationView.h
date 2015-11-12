//
//  UIViewController+MZLAnnotationView.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-7-22.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZLRouteAnnotation;

@interface UIViewController (MZLAnnotationView)

- (MKAnnotationView *)bubbleAnnotationForMapView:(MKMapView *)mapView withAnnotation:(MZLRouteAnnotation *)routeAnnotation isSelected:(BOOL)selected;
- (void)setAnnotationViewSelected:(MKAnnotationView *)annotationView flag:(BOOL)flag;
- (UIImage *)bubbleImage:(BOOL)isSelected;

- (UIView *)navCalloutViewForAnnotation:(id<MKAnnotation>)annotation;

@end

