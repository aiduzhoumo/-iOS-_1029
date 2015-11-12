//
//  MZLPagingSvcParam.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-25.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZLPagingSvcParam : NSObject

@property (nonatomic, assign) NSInteger lastId;
/** start from 1 */
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger fetchCount;

- (NSDictionary *)toDictionary;

+ (MZLPagingSvcParam *)pagingSvcParamWithLastId:(NSInteger)lastId fetchCount:(NSInteger)fetchCount;
+ (MZLPagingSvcParam *)pagingSvcParamWithPageIndex:(NSInteger)pageIndex fetchCount:(NSInteger)fetchCount;

@end
