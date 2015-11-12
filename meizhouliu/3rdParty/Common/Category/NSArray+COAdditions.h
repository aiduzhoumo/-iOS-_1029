//
//  NSArray+COAdditions.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-11.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

// typedef id (^BLOCK_MAP)(id value);

@interface NSArray (COAdditions)

- (NSDictionary *)groupBy:(NSString *)groupField;
- (NSDictionary *)groupBy:(NSString *)groupField filterOnValue:(CO_BLOCK_MAP)filterBlock;

@end
