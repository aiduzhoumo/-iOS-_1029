//
//  MZLRegister3rdPartySvcParam.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-13.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLRegister3rdPartySvcParam.h"
#import "MZLSharedData.h"
#import "MZLAppUser.h"

@implementation MZLRegister3rdPartySvcParam

- (NSMutableDictionary *)toMutableDictionary {
    NSMutableDictionary *result = [super toMutableDictionary];
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

+ (instancetype)instance {
    MZLRegister3rdPartySvcParam *result = [super instance];
    MZLAppUser *user = [MZLSharedData appUser];
    result.openID = user.openIdFrom3rdParty;
    result.token = user.tokenFrom3rdParty;
    result.expiresIn = user.expirationFrom3rdParty;
    result.nickName = user.nickNameFrom3rdParty;
    result.photo = user.imageUrlFrom3rdParty;
    return result;
}

@end
