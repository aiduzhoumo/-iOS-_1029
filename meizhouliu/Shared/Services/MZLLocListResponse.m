//
//  MZLLocListResponse.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-7-8.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLLocListResponse.h"

@implementation MZLLocListResponse

- (BOOL)isSystemLocationList {
    return [@"system" isEqualToString:self.type];
}

- (BOOL)isDefaultLocationList {
    return [@"default" isEqualToString:self.type];
}

- (BOOL)isSpecialLocationList {
    return [@"special" isEqualToString:self.type];
}

@end
