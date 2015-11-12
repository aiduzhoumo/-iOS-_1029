//
//  MZLRegisterTencentQqSvcParam.h
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-11.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLRegister3rdPartySvcParam.h"

@interface MZLRegisterTencentQqSvcParam : MZLRegister3rdPartySvcParam

@property (nonatomic , copy) NSString *openID;
@property (nonatomic , copy) NSString *token;
@property (nonatomic , copy) NSString *expiresIn;
@property (nonatomic , copy) NSString *refreshToken;
@property (nonatomic , copy) NSString *photo;

- (NSMutableDictionary *)toDictionary;

+ (MZLRegisterTencentQqSvcParam *)registerSvcParamWithmachineId:(NSString *)machineId openID:(NSString *)openID token:(NSString *)token expiresIn:(NSString *)expiresIn refreshToken:(NSString *)refreshToken nickName:(NSString *)nickName photo:(NSString *)photo;

@end
