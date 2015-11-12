//
//  MZLModelGoodsDetail.m
//  mzl_mobile_ios
//
//  Created by race on 14/12/17.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelGoodsDetail.h"

@implementation MZLModelGoodsDetail

+ (NSMutableDictionary *)attributeDictionary {
    return [[super attributeDictionary] fromPath:@"description" toProperty:@"goodsDesp"];
}

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
    [mapping addRelationFromPath:@"product" toProperty:@"goodsInfo" withMapping:[MZLModelGoods rkObjectMapping]];
}

@end
