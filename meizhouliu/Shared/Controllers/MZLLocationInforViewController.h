//
//  MZLLocationInforViewController.h
//  mzl_mobile_ios
//
//  Created by race on 14/10/21.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLBaseViewController.h"
#import <MapKit/MapKit.h>

@class MZLModelLocationDetail;

@interface MZLLocationInforViewController : MZLBaseViewController <UIScrollViewDelegate, MKMapViewDelegate>

@property (nonatomic , strong)MZLModelLocationDetail *locationDetail;

@end
