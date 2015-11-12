//
//  MZLModelSurroundingLocations.h
//  mzl_mobile_ios
//
//  Created by race on 15/1/5.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"

@class MZLModelLocationExt;

@interface MZLModelSurroundingLocations : MZLModelObject

@property (nonatomic, assign) NSInteger productsCount;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, strong) MZLModelLocationExt *locationExt;

// properties from AMap service
/** 高德字段，ID */
@property (nonatomic, copy) NSString *aMapId;
/** 高德字段，类型 */
@property (nonatomic, copy) NSString *aMapType;
/** 高德字段，省级代码 */
@property (nonatomic, copy) NSString *aMapPCode;
/** 高德字段，市级代码 */
@property (nonatomic, copy) NSString *aMapCityCode;

@property(nonatomic, readonly) NSString *address;
@property(nonatomic, readonly) NSString *introduction;

- (NSString *)distanceInKm;

@end
