//
//  MZLArticleListSvcParam.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-16.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLArticleListSvcParam.h"
#import "MZLPagingSvcParam.h"

@interface MZLArticleListSvcParam() {
    MZLPagingSvcParam *_pagingParam;
}

@end

@implementation MZLArticleListSvcParam

- (MZLPagingSvcParam *)pagingParam {
    if (! _pagingParam) {
        _pagingParam = [[MZLPagingSvcParam alloc]init];
    }
    return _pagingParam;
}

- (void)setPaging:(MZLPagingSvcParam *)paging {
    _pagingParam = paging;
}

- (NSInteger)lastArticleId {
    return [self pagingParam].lastId;
}

- (NSInteger)fetchCount {
    return [self pagingParam].fetchCount;
}

- (NSInteger)pageIndex {
    return [self pagingParam].pageIndex;
}

- (void)setLastArticleId:(NSInteger)lastArticleId {
    MZLPagingSvcParam *pagingParam = [self pagingParam];
    pagingParam.lastId = lastArticleId;
}

- (void)setFetchCount:(NSInteger)fetchCount {
    MZLPagingSvcParam *pagingParam = [self pagingParam];
    pagingParam.fetchCount = fetchCount;
}

- (void)setPageIndex:(NSInteger)pageIndex {
    MZLPagingSvcParam *pagingParam = [self pagingParam];
    pagingParam.pageIndex = pageIndex;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *result = (NSMutableDictionary *)[[self pagingParam] toDictionary];
    // locationId, locationName 取其一
    if (self.locationId > 0) {
        result[@"destination_id"] = @(self.locationId);
    } else if (self.locationName) {
        result[@"destination_name"] = self.locationName;
    }
    return result;
}

+ (MZLArticleListSvcParam *)instanceWithDefaultPagingParam {
    MZLArticleListSvcParam * result = [[MZLArticleListSvcParam alloc] init];
    result.pageIndex = 1;
    result.fetchCount = MZL_SVC_FETCHCOUNT;
    return result;
}

@end
