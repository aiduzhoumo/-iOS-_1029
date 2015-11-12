//
//  MZLModelTagDesp.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-12-12.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelTagDesp.h"

@implementation MZLModelTagDesp

+ (NSMutableDictionary *)attributeDictionary {
    return [[super attributeDictionary] fromPath:@"description" toProperty:@"desp"];
}

@end
