//
//  MZLModelGoods.m
//  mzl_mobile_ios
//
//  Created by race on 14/12/8.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelGoods.h"

@implementation MZLModelGoods

#pragma mark - restkit mapping

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
//    [mapping addRelationFromPath:@"photo" toProperty:@"coverImg" withMapping:[MZLModelImage rkObjectMapping]];
    [mapping addRelationFromPath:@"img" toProperty:@"coverImg" withMapping:[MZLModelImage rkObjectMapping]];
}

+ (NSMutableDictionary *)attributeDictionary {
    NSMutableDictionary *attrDict = [super attributeDictionary];
//    [attrDict fromPath:@"title" toProperty:@"title"];
//    [attrDict fromPath:@"show_price" toProperty:@"price"];
    [attrDict fromPath:@"title" toProperty:@"title"];
    [attrDict fromPath:@"minPrice" toProperty:@"price"];
    [attrDict fromPath:@"detailUrl" toProperty:@"goodsUrl"];
    [attrDict fromPath:@"cityName" toProperty:@"cityName"];
    
    return attrDict;
}

//- (NSString *)goodsUrl {
//    return  [NSString stringWithFormat:@"%@/products/%ld", MZL_BASE_URL, self.identifier];
//}

+ (instancetype)GoodsWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.title = dic[@"title"];
        self.imageUrl = dic[@"img"];
        self.price = [[dic objectForKey:@"minPrice"] intValue];
        self.goodsUrl = dic[@"detailUrl"];
    }
    return self;
}




@end
