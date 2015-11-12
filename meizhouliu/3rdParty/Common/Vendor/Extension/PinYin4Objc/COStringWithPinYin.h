//
//  COStringWithPinYin.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-20.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface COStringWithPinYin : NSObject

@property (nonatomic, copy) NSString *str;
@property (nonatomic, copy) NSString *pinyin;
@property (nonatomic, copy) NSString *pinyinCapital;

+ (instancetype)instanceFromString:(NSString *)str;

- (NSDictionary *)toDictionary;
+ (instancetype)instanceFromDictionary:(NSDictionary *)dict;

@end
