//
//  NSObject+CORestKitMapping.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-26.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "NSObject+CORestKitMapping.h"

@implementation NSObject (CORestKitMapping)

/** property and key path are the same */
+ (NSMutableArray *)attrArray {
    return [NSMutableArray array];
}

+ (NSMutableDictionary *)attributeDictionary {
    return [NSMutableDictionary dictionary];
}

+ (void)addAttributeMapping:(RKObjectMapping *)mapping {
    [mapping addAttributeMappingsFromArray:[self attrArray]];
    [mapping addAttributeMappingsFromDictionary:[self attributeDictionary]];
}


+ (void)addRelationMapping:(RKObjectMapping *)mapping {
}

+ (RKObjectMapping *)rkObjectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    [self addAttributeMapping:mapping];
    [self addRelationMapping:mapping];
    return mapping;
}

@end
