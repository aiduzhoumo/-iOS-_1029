//
//  MZLRegisterSvcParam.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-7-31.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLRegisterBaseSvcParam.h"
#import "MZLSharedData.h"

@implementation MZLRegisterBaseSvcParam

- (NSDictionary *)toDictionary {
    return [NSDictionary dictionaryWithDictionary:[self toMutableDictionary]];
}

- (NSMutableDictionary *)toMutableDictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (! isEmptyString(self.machineId)) {
        result[MZL_KEY_MACHINE_ID] = self.machineId;
    }
    return result;
}

- (NSMutableDictionary *)mutableDict:(NSDictionary *)dict {
    return [NSMutableDictionary dictionaryWithDictionary:dict];
}

+ (instancetype)instance {
    MZLRegisterBaseSvcParam *result = [[[self class] alloc] init];
    result.machineId = [MZLSharedData appMachineId];
    return result;
}

//- (void)setNickName:(NSString *)nickName
//{
//    _nickName = [nickName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//}

//- (NSString *)nickName {
//  
//    return [_nickName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//}

@end
