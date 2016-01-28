//
//  MZLShortArticlesModel.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/8.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"

@class MZLModelImage;
@interface MZLShortArticlesModel : MZLModelObject

@property (nonatomic, strong) MZLModelImage *cover;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)modelWithDic:(NSDictionary *)dic;
@end
