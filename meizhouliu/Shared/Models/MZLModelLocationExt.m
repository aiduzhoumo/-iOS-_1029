//
//  MZLModelLocationExt.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-26.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelLocationExt.h"

@implementation MZLModelLocationExt

+ (NSMutableDictionary *)attributeDictionary {
    NSMutableDictionary *attrDict = [super attributeDictionary];
    [attrDict fromPath:@"full_address" toProperty:@"address"];
    [attrDict fromPath:@"description" toProperty:@"introduction"];
    return attrDict;
}

@end
