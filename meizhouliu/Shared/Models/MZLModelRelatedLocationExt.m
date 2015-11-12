//
//  MZLModelDescendantInfo.m
//  mzl_mobile_ios
//
//  Created by race on 14/12/22.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelRelatedLocationExt.h"

@implementation MZLModelRelatedLocationExt

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
    
    [mapping addRelationFromPath:@"cover" toProperty:@"coverImg" withMapping:[MZLModelImage rkObjectMapping]];
    
    [mapping addRelationFromPath:@"destination_detail" toProperty:@"locatinExt" withMapping:[MZLModelLocationExt rkObjectMapping]];
    
}
@end
