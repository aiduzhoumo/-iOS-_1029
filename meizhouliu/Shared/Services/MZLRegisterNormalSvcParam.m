//
//  MZLRegisterNormalSvcParam.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-11.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLRegisterNormalSvcParam.h"

@implementation MZLRegisterNormalSvcParam

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (!isEmptyString(self.machineId)) {
        result[@"machine_id"] = self.machineId;
    }
    if (!isEmptyString(self.nickName)) {
        result[@"user[nickname]"] = self.nickName;
    }
    if (!isEmptyString(self.email)) {
        result[@"user[email]"] = self.email;
    }
    if (!isEmptyString(self.password)) {
        result[@"user[password]"] = self.password;
    }
    return result;
}

+ (MZLRegisterNormalSvcParam *)registerSvcParamWithmachineId:(NSString *)machineId email:(NSString *)email nickName:(NSString *)nickName password:(NSString *)password{
    MZLRegisterNormalSvcParam *result = [[MZLRegisterNormalSvcParam alloc] init];
    result.machineId = machineId;
    result.email = email;
    result.nickName = nickName;
    result.password = password;
    return result;
}
@end
