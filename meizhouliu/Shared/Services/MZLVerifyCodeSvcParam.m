//
//  MZLVerifyCodeSvcParam.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/25.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLVerifyCodeSvcParam.h"

@implementation MZLVerifyCodeSvcParam

- (NSMutableDictionary *)toDictionary {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    if (!isEmptyString(self.phone)) {
        result[@"phone"] = self.phone;
    }
    if (!isEmptyString(self.type)) {
        result[@"type"] = self.type;
    }
    if (!isEmptyString(self.code)) {
        result[@"code"] = self.code;
    }
    return result;
}
@end
