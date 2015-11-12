//
//  MZLSelectedRouteCell.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-21.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLRouteCell.h"

#define HEIGHT_SELECTED_ROUTE_CELL 140.0

@class MZLModelLocationBase, MZLModelUserLocationPref, MZLArticleDetailNavVwController;

@interface MZLSelectedRouteCell : MZLRouteCell



@property (weak, nonatomic) IBOutlet UILabel *lblIndex;

@property (weak, nonatomic) IBOutlet UIView *vwInterest;
@property (weak, nonatomic) IBOutlet UIImageView *imgInterest;

@property (weak, nonatomic) IBOutlet UIView *vwPlay;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayTip1;
@property (weak, nonatomic) IBOutlet UILabel *lblPlay;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayTip2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cImgDotTop;

@property (nonatomic, weak) MZLModelLocationBase *location;
@property (nonatomic, weak) MZLArticleDetailNavVwController *ownerController;
@property (nonatomic, weak) MZLModelUserLocationPref *userLocPref;

- (void)adjustLayout;
- (CGFloat)fitHeight;

@end
