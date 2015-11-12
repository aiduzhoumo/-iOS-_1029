//
//  NSArray+COAdditions.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-11.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "NSArray+COAdditions.h"

@implementation NSArray (COAdditions)

- (NSDictionary *)groupBy:(NSString *)groupField {
    return [self groupBy:groupField filterOnValue:nil];
}

- (NSDictionary *)groupBy:(NSString *)groupField filterOnValue:(CO_BLOCK_MAP)filterBlock {
    
    NSString* (^groupFieldValueBlock)(id value) = ^(id value) {
        return [value valueForKey:groupField];
    };
    
    CO_BLOCK_MAP valueBlock = ^(id value) {
        return filterBlock ? filterBlock(value) : value;
    };
    
    if (self.count == 0) {
        return nil;
    } else if (self.count == 1) {
        id onlyElement = [self objectAtIndex:0];
        NSString *groupKey = groupFieldValueBlock(onlyElement);
        return @{groupKey : @[valueBlock(onlyElement)]};
    } else {
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:groupField ascending:YES];
        NSArray *sorted = [self sortedArrayUsingDescriptors:@[descriptor]];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSMutableArray *valueArray = [NSMutableArray array];
        id element = [sorted objectAtIndex:0];
        NSString *groupKey = groupFieldValueBlock(element);
        [valueArray addObject:valueBlock(element)];
        [dict setObject:valueArray forKey:groupKey];
        for (int i = 1; i < sorted.count; i++) {
            id tempElement = [sorted objectAtIndex:i];
            NSString *tempKey = groupFieldValueBlock(tempElement);
            if (! ([tempKey isEqualToString:groupKey])) {
                groupKey = tempKey;
                valueArray = [NSMutableArray array];
                [valueArray addObject:valueBlock(tempElement)];
                [dict setObject:valueArray forKey:groupKey];
            } else {
                [valueArray addObject:valueBlock(tempElement)];
            }
        }
        return dict;
    }
}

@end
