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
    [mapping addRelationFromPath:@"photo" toProperty:@"coverImg" withMapping:[MZLModelImage rkObjectMapping]];
}

+ (NSMutableDictionary *)attributeDictionary {
    NSMutableDictionary *attrDict = [super attributeDictionary];
    [attrDict fromPath:@"title" toProperty:@"title"];
    [attrDict fromPath:@"show_price" toProperty:@"price"];
    
    return attrDict;
}

- (NSString *)goodsUrl {
    return  [NSString stringWithFormat:@"%@/products/%d", MZL_BASE_URL, self.identifier];
}

@end
