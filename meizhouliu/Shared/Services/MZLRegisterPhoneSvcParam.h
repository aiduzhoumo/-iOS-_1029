//
//  MZLRegisterPhoneSvcParam.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/20.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLRegisterBaseSvcParam.h"

@interface MZLRegisterPhoneSvcParam : MZLRegisterBaseSvcParam

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *secCode;

- (NSMutableDictionary *)toDictionary;

+ (MZLRegisterPhoneSvcParam *)registerSvcParamWithmachineId:(NSString *)machineId phone:(NSString *)phone nickName:(NSString *)nickName password:(NSString *)password;

@end
