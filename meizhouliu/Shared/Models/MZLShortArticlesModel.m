//
//  MZLShortArticlesModel.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/8.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import "MZLShortArticlesModel.h"
#import "MZLModelImage.h"

@implementation MZLShortArticlesModel

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
    
    [mapping addRelationFromPath:@"cover" toProperty:@"cover" withMapping:[MZLModelImage rkObjectMapping]];

}

+ (NSMutableDictionary *)attributeDictionary {
    return [super attributeDictionary];
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    self.identifier = [dic[@"id"] integerValue];
    self.cover = dic[@"cover"];
    return self;
}
+ (instancetype)modelWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
@end
