//
//  CORestKitMappingExtension.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-26.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RKObjectMapping.h>
#import <RKMapping.h>
#import <RKRelationshipMapping.h>

@interface CORestKitMappingExtension : NSObject

@end

@interface NSMutableArray (CORestKitMappingExtension)

- (NSMutableArray *)addArray:(NSArray *)array;
- (NSMutableArray *)co_addObject:(id)object;

@end

@interface NSMutableDictionary (CORestKitMappingExtension)

- (NSMutableDictionary *)fromPath:(NSString *)path toProperty:(NSString *)property;

@end

@interface RKObjectMapping (CORestKitMappingExtension)

- (RKObjectMapping *)addRelationFromPath:(NSString *)path toProperty:(NSString *)property withMapping:(RKMapping *)mapping;
/** path and property are the same */
- (RKObjectMapping *)addRelationWithPath:(NSString *)path andMapping:(RKMapping *)mapping;


@end
