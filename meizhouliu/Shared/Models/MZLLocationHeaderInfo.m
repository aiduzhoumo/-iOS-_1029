//
//  MZLLocationHeaderInfo.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-16.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLLocationHeaderInfo.h"
#import "MZLModelLocation.h"

@implementation MZLLocationHeaderInfo

+ (MZLLocationHeaderInfo *)instanceFromDictionary:(NSDictionary *)dict {
    MZLLocationHeaderInfo *locHeaderInfo = [[MZLLocationHeaderInfo alloc] init];
    locHeaderInfo.startY = [(NSNumber *)dict[@"top"] integerValue];
    locHeaderInfo.endY = [(NSNumber *)dict[@"bottom"] integerValue];
    MZLModelLocation *loc = [[MZLModelLocation alloc] init];
    loc.identifier = [(NSNumber *)dict[@"id"] integerValue];
    loc.name = dict[@"name"];
    locHeaderInfo.location = loc;
    return locHeaderInfo;
}

- (void)verifyHeightGreaterOrEqualTo:(CGFloat)minimumHeight {
    if (self.endY - self.startY < minimumHeight) {
        self.endY = self.startY + minimumHeight;
    }
}

@end
