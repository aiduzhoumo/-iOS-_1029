//
//  MZLChildLocationsSvcParam.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-4.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MZLPagingSvcParam;

@interface MZLChildLocationsSvcParam : NSObject

@property (nonatomic, assign) NSInteger parentLocationId;
@property (nonatomic, assign) NSInteger category;
@property (nonatomic, strong) MZLPagingSvcParam *pagingParam;

- (NSDictionary *)toDictionary;

@end
