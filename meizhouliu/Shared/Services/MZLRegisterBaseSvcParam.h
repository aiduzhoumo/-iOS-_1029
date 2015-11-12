//
//  MZLRegisterSvcParam.h
//  mzl_mobile_ios
//
//  Created by alfred on 14-7-31.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZLRegisterBaseSvcParam : NSObject

@property (nonatomic, copy) NSString *machineId;
@property (nonatomic, copy) NSString *nickName;

- (NSDictionary *)toDictionary;
- (NSMutableDictionary *)toMutableDictionary;
//- (NSMutableDictionary *)mutableDict:(NSDictionary *)dict;

+ (instancetype)instance;

@end
