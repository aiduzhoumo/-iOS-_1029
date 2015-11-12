//
//  MZLLocationMapViewController.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-22.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MZLBaseViewController.h"

@class MKMapView, MZLModelLocationDetail;

@interface MZLLocationMapViewController : MZLBaseViewController<MKMapViewDelegate>

@property (nonatomic, strong) MZLModelLocationDetail *location;

@property (weak, nonatomic) IBOutlet MKMapView *mapLocation;
@property (weak, nonatomic) IBOutlet UIView *vwLocBg;
@property (weak, nonatomic) IBOutlet UILabel *lblLocName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cLocBottom;

@end
