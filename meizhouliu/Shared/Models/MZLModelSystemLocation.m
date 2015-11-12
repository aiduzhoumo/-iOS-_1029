//
//  MZLModelSystemLocation.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-19.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelSystemLocation.h"

@implementation MZLModelSystemLocation

+ (NSMutableArray *)attrArray {
    return [[super attrArray] co_addObject:@"name"];
}

#pragma mark - coding

#define KEY_SYSTEM_LOCATION_NAME @"KEY_SYSTEM_LOCATION_NAME"

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.name = [aDecoder decodeObjectForKey:KEY_SYSTEM_LOCATION_NAME];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.name forKey:KEY_SYSTEM_LOCATION_NAME];
}

@end
