//
//  MZLModelGoodsDetail.h
//  mzl_mobile_ios
//
//  Created by race on 14/12/17.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"
#import "MZLModelGoods.h"

@interface MZLModelGoodsDetail : MZLModelObject

@property (nonatomic, copy) NSString *goodsDesp;

@property (nonatomic, strong) MZLModelGoods *goodsInfo;

@end
