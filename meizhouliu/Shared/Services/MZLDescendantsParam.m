//
//  MZLDescendantsParam.m
//  mzl_mobile_ios
//
//  Created by race on 14/12/22.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLDescendantsParam.h"

@implementation MZLDescendantsParam

+ (MZLDescendantsParam *)descendantsParamsFromDescendants:(NSArray *)descendantIds {
    MZLDescendantsParam *param = [[MZLDescendantsParam alloc] init];
    [param toServiceParamValue:descendantIds];
    param.descendantIds = [param toServiceParamValue:descendantIds];
    return param;
}


- (NSString *)toServiceParamValue:(NSArray *)descendantIds {
    return [descendantIds componentsJoinedByString:@","];
}

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    result[@"ids"] = self.descendantIds;

    return result;
}
@end
