//
//  MZLModelGoods.h
//  mzl_mobile_ios
//
//  Created by race on 14/12/8.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"
#import "MZLModelImage.h"

@interface MZLModelGoods : MZLModelObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, strong) MZLModelImage *coverImg;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, assign) NSInteger sold;

@property (nonatomic, copy) NSString *goodsUrl;

@property (nonatomic, copy) NSString *cityName;

+ (instancetype)GoodsWithDic:(NSDictionary *)dic;
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
