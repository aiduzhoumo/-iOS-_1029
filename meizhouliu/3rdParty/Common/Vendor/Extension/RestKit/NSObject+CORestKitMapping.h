//
//  NSObject+CORestKitMapping.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-26.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CORestKitMapping.h"
#import "CORestKitMappingExtension.h"

@interface NSObject (CORestKitMapping) <CORestKitMapping>

/** protected for override */
+ (NSMutableArray *)attrArray;
+ (NSMutableDictionary *)attributeDictionary;
+ (void)addRelationMapping:(RKObjectMapping *)mapping;

@end
