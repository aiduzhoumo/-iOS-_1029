//
//  MZLModelUserLocationPref.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-23.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"

@class MZLModelLocation;

@interface MZLModelUserLocationPref : MZLModelObject

//@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) NSInteger locationId;
@property (nonatomic, strong) MZLModelLocation *location;

@end
