//
//  MZLChildLocationsSvcParam.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-4.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLChildLocationsSvcParam.h"
#import "MZLPagingSvcParam.h"

@implementation MZLChildLocationsSvcParam

- (NSDictionary *)toDictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (self.category > 0) {
        result[@"category_id"] = @(self.category);
    }
    if (self.pagingParam) {
        [result addEntriesFromDictionary:[self.pagingParam toDictionary]];
    }
    return result;
}

@end
