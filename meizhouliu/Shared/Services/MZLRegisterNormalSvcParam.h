//
//  MZLRegisterNormalSvcParam.h
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-11.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLRegisterBaseSvcParam.h"

@interface MZLRegisterNormalSvcParam : MZLRegisterBaseSvcParam

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;


- (NSMutableDictionary *)toDictionary;

+ (MZLRegisterNormalSvcParam *)registerSvcParamWithmachineId:(NSString *)machineId email:(NSString *)email nickName:(NSString *)nickName password:(NSString *)password;

@end
