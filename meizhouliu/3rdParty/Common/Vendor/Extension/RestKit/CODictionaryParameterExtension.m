//
//  CODictionaryParameterExtension.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-26.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "CODictionaryParameterExtension.h"
#import "COUtils.h"

@implementation CODictionaryParameterExtension

@end

@implementation NSMutableDictionary (CODictionaryParameterExtension)

- (NSMutableDictionary *)setKey:(NSString *)key intValue:(NSInteger)intValue {
    if (intValue > 0) {
        [self setObject:@(intValue) forKey:key];
    }
    return self;
}

- (NSMutableDictionary *)setKey:(NSString *)key strValue:(NSString *)strValue {
    if (! isEmptyString(strValue)) {
        [self setObject:strValue forKey:key];
    }
    return self;
}

@end