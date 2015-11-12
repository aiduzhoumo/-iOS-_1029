//
//  MZLMessagesResponse.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-4.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLServiceResponseDetail.h"
#import "NSObject+CORestKitMapping.h"

@implementation MZLServiceResponseDetail

+ (NSMutableArray *)attrArray {
    // array of string mapped to attribute
    return [[super attrArray] addArray:@[@"field", @"detail"]];
}

@end
