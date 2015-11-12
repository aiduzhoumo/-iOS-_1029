//
//  MZLArticleDetailPOINavVwController.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-7-22.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MZLBaseViewController.h"

@class MZLLocationRouteInfo, MZLArticleDetailNavVwController;

@interface MZLArticleDetailPOINavVwController : MZLBaseViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIView *bgStatusBar;

@property (nonatomic, weak) MZLArticleDetailNavVwController *articleCtrl;
@property (nonatomic, weak) MZLLocationRouteInfo *selectedRouteInfo;

- (void)setAnnotations:(NSArray *)annotations;
- (void)setSelectedLocation:(MZLLocationRouteInfo *)location;

@end
