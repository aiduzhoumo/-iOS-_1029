//
//  MZLLocationRouteInfo.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-27.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLLocationRouteInfo.h"

@implementation MZLLocationRouteInfo

- (NSInteger)locationId {
    if (self.location) {
        return self.location.identifier;
    }
    return -1;
}

@end
