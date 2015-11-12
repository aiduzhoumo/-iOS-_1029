//
//  MZLArticleListSvcParam.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-16.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MZLPagingSvcParam;

@interface MZLArticleListSvcParam : NSObject

@property (nonatomic, assign) NSInteger lastArticleId;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger fetchCount;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, assign) NSInteger locationId;

- (NSDictionary *)toDictionary;

- (void)setPaging:(MZLPagingSvcParam *)paging;

+ (MZLArticleListSvcParam *)instanceWithDefaultPagingParam;

@end
