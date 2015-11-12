//
//  CORestKitMappingExtension.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-26.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "CORestKitMappingExtension.h"

@implementation CORestKitMappingExtension

@end

@implementation NSMutableArray (CORestKitMappingExtension)

- (NSMutableArray *)addArray:(NSArray *)array {
    [self addObjectsFromArray:array];
    return self;
}

- (NSMutableArray *)co_addObject:(id)object {
    [self addObject:object];
    return self;
}

@end

@implementation NSMutableDictionary (CORestKitMappingExtension)

- (NSMutableDictionary *)fromPath:(NSString *)path toProperty:(NSString *)property {
    [self setObject:property forKey:path];
    return self;
}

@end

@implementation RKObjectMapping (CORestKitMappingExtension)

- (RKObjectMapping *)addRelationFromPath:(NSString *)path toProperty:(NSString *)property withMapping:(RKMapping *)mapping {
    RKRelationshipMapping *relationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:path toKeyPath:property withMapping:mapping];
    [self addPropertyMapping:relationshipMapping];
    return self;
}

- (RKObjectMapping *)addRelationWithPath:(NSString *)path andMapping:(RKMapping *)mapping {
    return [self addRelationFromPath:path toProperty:path withMapping:mapping];
}

@end
