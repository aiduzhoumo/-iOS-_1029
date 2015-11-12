//
//  NSObject+CODictionaryParameter.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-26.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "NSObject+CODictionaryParameter.h"

@implementation NSObject (CODictionaryParameter)

- (NSMutableDictionary *)_toDictionary {
    return [NSMutableDictionary dictionary];
}

- (NSDictionary *)toDictionary {
    return [NSDictionary dictionaryWithDictionary:[self _toDictionary]];
}

@end
