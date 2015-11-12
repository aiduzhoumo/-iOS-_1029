//
//  MZLArticleDetailNavVwController.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-12.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MZLModelArticleDetail, MZLModelUserLocationPref, MZLLocationRouteInfo, MZLModelLocationBase;

@interface MZLArticleDetailNavVwController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *vwContent;
@property (weak, nonatomic) IBOutlet UIView *vwContentLeft;
@property (weak, nonatomic) IBOutlet UIView *vwBackArrow;
@property (weak, nonatomic) IBOutlet UIView *vwContentInner;
@property (weak, nonatomic) IBOutlet UIView *vwLocation;

@property (weak, nonatomic) IBOutlet UILabel *lblRoute;
@property (weak, nonatomic) IBOutlet UILabel *lblCurLoc;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;


@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (nonatomic, strong) MZLModelArticleDetail *article;
@property (nonatomic, strong) MZLLocationRouteInfo *targetLocationRouteInfo;
/** instances of MZLModelUserLocationPref */
@property (nonatomic, strong) NSMutableArray *favoredLocations;
@property (nonatomic, assign) BOOL ignoreParentScroll;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vwArrowHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vwArrowMarginBottom;
- (MZLLocationRouteInfo *)locRouteInfoFromIndex:(NSInteger)index;

- (void)addArticleFavoredLocation:(MZLModelUserLocationPref *)userlocPref;
- (void)removeArticleFavoredLocation:(MZLModelUserLocationPref *)userlocPref;

- (void)toLocationDetail:(MZLModelLocationBase *)location;

- (void)hideWithAnimation:(void (^)(void))animationFinishedBlock;

- (NSArray *)getAnnotations;
- (MZLLocationRouteInfo *)getSelectedLocation;

@end
