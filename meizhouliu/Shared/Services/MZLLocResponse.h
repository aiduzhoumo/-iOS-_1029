//
//  MZLLocResponse.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15/4/28.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLServiceResponseObject.h"

@class MZLModelSurroundingLocations;

@interface MZLLocResponse : MZLServiceResponseObject

@property (nonatomic, strong) MZLModelSurroundingLocations *destination;

@end
