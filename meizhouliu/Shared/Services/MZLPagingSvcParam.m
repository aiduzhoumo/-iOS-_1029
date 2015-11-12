//
//  MZLPagingSvcParam.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-25.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLPagingSvcParam.h"

@implementation MZLPagingSvcParam

- (NSDictionary *) toDictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (self.lastId > 0) {
        result[@"last_id"] = @(self.lastId);
    }
    if (self.fetchCount > 0) {
        result[@"per"] = @(self.fetchCount);
    }
    if (self.pageIndex > 0) {
        result[@"page"] = @(self.pageIndex);
    }
    return result;
}

+ (MZLPagingSvcParam *)pagingSvcParamWithLastId:(NSInteger)lastId fetchCount:(NSInteger)fetchCount {
    MZLPagingSvcParam *result = [[MZLPagingSvcParam alloc] init];
    result.lastId = lastId;
    result.fetchCount = fetchCount;
    return result;
}

+ (MZLPagingSvcParam *)pagingSvcParamWithPageIndex:(NSInteger)pageIndex fetchCount:(NSInteger)fetchCount {
    MZLPagingSvcParam *result = [[MZLPagingSvcParam alloc] init];
    result.pageIndex = pageIndex;
    result.fetchCount = fetchCount;
    return result;
}

@end
