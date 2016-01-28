//
//  MZLPhoneLoginSvcParam.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/25.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLPhoneLoginSvcParam.h"
#import "MZLSharedData.h"

@implementation MZLPhoneLoginSvcParam

- (NSDictionary *)toDictionary {

    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    if (!isEmptyString(self.phoneNum)) {
        result[@"phone"] = self.phoneNum;
    }
    if (!isEmptyString(self.passWord)) {
        result[@"password"] = self.passWord;
    }
    if (!isEmptyString(self.machineId)) {
        result[@"machine_id"] = self.machineId;
    }
    return result;
}

+ (MZLPhoneLoginSvcParam *)phoneLoginSvcParamWithPhoneNum:(NSString *)phoneNum password:(NSString *)password {
    
    MZLPhoneLoginSvcParam *param = [[MZLPhoneLoginSvcParam alloc] init];
    param.phoneNum = phoneNum;
    param.passWord = password;
//    param.machineId = [MZLSharedData appMachineId];
    return param;
}

+ (instancetype)instance {
    MZLPhoneLoginSvcParam *result = [[[self class] alloc] init];
    result.machineId = [MZLSharedData appMachineId];
    return result;
}

@end
