//
//  MZLLocDetailHeaderAddressView.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-6-5.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeView.h"

@class MZLModelLocationDetail, MZLModelUserLocationPref;

@interface MZLLocDetailHeaderAddressView : WeView

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIView *vwInterestClickable;
@property (weak, nonatomic) IBOutlet UIImageView *image;

+ (id)instance:(MZLModelLocationDetail *)locationDetail userLocPref:(MZLModelUserLocationPref *)userLocPref;

//- (void)toggleImage:(MZLModelUserLocationPref *)userLocPref;

@end
