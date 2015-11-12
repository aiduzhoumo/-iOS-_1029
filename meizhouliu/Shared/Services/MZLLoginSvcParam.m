//
//  MZLLoginSvcParam.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-7-31.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLLoginSvcParam.h"

@implementation MZLLoginSvcParam

- (NSDictionary *)toDictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    if (!isEmptyString(self.name)) {
        result[@"name"] = self.name;
    }
    if (!isEmptyString(self.password)) {
        result[@"password"] = self.password;
    }
    return result;
}

+ (MZLLoginSvcParam *)loginSvcParamWithname:(NSString *)name password:(NSString *)password{
    MZLLoginSvcParam *result = [[MZLLoginSvcParam alloc] init];
    result.name = name;
    result.password = password;
    return result;
}

@end
