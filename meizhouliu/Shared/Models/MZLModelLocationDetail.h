//
//  MZLModelLocationDetail.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-22.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelLocationBase.h"

@interface MZLModelLocationDetail : MZLModelLocationBase

@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSArray *tagTypes;
@property (nonatomic, strong) NSArray *tagDesps;
@property (nonatomic, readonly) NSString *tagDesp;

@property (nonatomic, assign) CGFloat averageConsumption;
@property (nonatomic, assign) NSInteger productsCount;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSArray *articles;
@property (nonatomic, strong) NSArray *locDesps;

@property (nonatomic, assign) NSInteger totalChildLocationCount;
@property (nonatomic, assign) NSInteger relatedLocationCount;
@property (nonatomic, copy) NSString *topParentName;
@property (nonatomic, strong) MZLModelLocationBase *topParent;
@property (nonatomic, strong) NSArray *childLocations;
@property (nonatomic, readonly) NSString *topParentLocationName;
@property (nonatomic, readonly) NSInteger topParentLocationId;

@end
