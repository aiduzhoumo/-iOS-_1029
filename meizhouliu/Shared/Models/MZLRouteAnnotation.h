//
//  MZLRouteAnnotation.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-22.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <MapKit/MapKit.h>

@class MZLLocationRouteInfo;

@interface MZLRouteAnnotation : MKPointAnnotation

@property (nonatomic, strong) MZLLocationRouteInfo *routeInfo;

@property (nonatomic, readonly) NSInteger index;

@end
