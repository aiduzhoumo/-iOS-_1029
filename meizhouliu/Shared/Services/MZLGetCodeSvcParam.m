//
//  MZLGetCodeSvcParam.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/25.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLGetCodeSvcParam.h"

@implementation MZLGetCodeSvcParam

- (NSMutableDictionary *)toDictionary {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    if (!isEmptyString(self.phone)) {
        result[@"phone"] = self.phone;
    }
    if (!isEmptyString(self.type)) {
        result[@"type"] = self.type;
    }
    return result;
}

@end
