//
//  MZLRegisterSinaWeiboSvcParam.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-11.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLRegisterSinaWeiboSvcParam.h"

@implementation MZLRegisterSinaWeiboSvcParam

+ (MZLRegisterSinaWeiboSvcParam *)registerSvcParamWithmachineId:(NSString *)machineId
                                                         openID:(NSString *)openID
                                                          token:(NSString *)token
                                                      expiresIn:(NSString *)expiresIn
                                                   refreshToken:(NSString *)refreshToken
                                                       nickName:(NSString *)nickName
                                                          photo:(NSString *)photo
{
    MZLRegisterSinaWeiboSvcParam *result = [[MZLRegisterSinaWeiboSvcParam alloc] init];
    result.machineId = machineId;
    result.openID = openID;
    result.token = token;
    result.expiresIn = expiresIn;
    result.refreshToken = refreshToken;
    result.nickName = nickName;
    result.photo = photo;
    return result;
}


- (NSMutableDictionary *)toDictionary{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (!isEmptyString(self.machineId)) {
        result[@"machine_id"] = self.machineId;
    }
    if (!isEmptyString(self.nickName)) {
        result[@"platform[open_id]"] = self.openID;
    }
    if (!isEmptyString(self.token)) {
        result[@"platform[token]"] = self.token;
    }
    if (!isEmptyString(self.expiresIn)) {
        result[@"platform[expires_in]"] = self.expiresIn;
    }
    if (!isEmptyString(self.refreshToken)) {
        result[@"platform[refresh_token]"] = self.refreshToken;
    }
    if (!isEmptyString(self.nickName)) {
        result[@"user[nickname]"] = self.nickName;
    }
    if (!isEmptyString(self.photo)) {
        result[@"photo"] = self.photo;
    }
    return result;
}

@end
