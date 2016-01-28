//
//  MZLRegisterPhoneSvcParam.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/20.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLRegisterPhoneSvcParam.h"

@implementation MZLRegisterPhoneSvcParam

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (!isEmptyString(self.machineId)) {
        result[@"machine_id"] = self.machineId;
    }
    if (!isEmptyString(self.nickName)) {
        result[@"user[nickname]"] = self.nickName;
    }
    if (!isEmptyString(self.phone)) {
        result[@"user[phone]"] = self.phone;
    }
    if (!isEmptyString(self.password)) {
        result[@"user[password]"] = self.password;
    }
    if (!isEmptyString(self.secCode)) {
        result[@"user[code]"] = self.secCode;
    }
    return result;
}

+ (MZLRegisterPhoneSvcParam *)registerSvcParamWithmachineId:(NSString *)machineId phone:(NSString *)phone nickName:(NSString *)nickName password:(NSString *)password{
    MZLRegisterPhoneSvcParam *result = [[MZLRegisterPhoneSvcParam alloc] init];
    result.machineId = machineId;
    result.phone = phone;
    result.nickName = nickName;
    result.password = password;
    return result;
}


@end
