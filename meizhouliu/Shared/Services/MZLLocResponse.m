//
//  MZLLocResponse.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15/4/28.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLLocResponse.h"
#import "MZLModelSurroundingLocations.h"

@implementation MZLLocResponse

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
    [mapping addRelationFromPath:@"destination" toProperty:@"destination" withMapping:[MZLModelSurroundingLocations rkObjectMapping]];
}

@end
