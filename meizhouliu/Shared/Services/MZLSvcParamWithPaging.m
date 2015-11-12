//
//  MZLSvcParamWithPaging.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-10.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLSvcParamWithPaging.h"

@implementation MZLSvcParamWithPaging

- (NSMutableDictionary *)_toDictionary {
    NSMutableDictionary *dict = [super _toDictionary];
    if (self.pagingParam) {
        [dict addEntriesFromDictionary:[self.pagingParam toDictionary]];
    }
    return dict;
}

@end
