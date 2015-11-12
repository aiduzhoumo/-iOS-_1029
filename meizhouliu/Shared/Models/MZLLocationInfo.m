//
//  MZLLocationInfo.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-9.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLLocationInfo.h"

#define KEY_LATITUDE @"KEY_LATITUDE"
#define KEY_LONGITUDE @"KEY_LONGITUDE"
#define KEY_CITY @"KEY_CITY"

@implementation MZLLocationInfo


#pragma mark - NSCoding protocol
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.latitude = [aDecoder decodeObjectForKey:KEY_LATITUDE];
        self.longitude = [aDecoder decodeObjectForKey:KEY_LONGITUDE];
        self.city = [aDecoder decodeObjectForKey:KEY_CITY];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.latitude forKey:KEY_LATITUDE];
    [aCoder encodeObject:self.longitude forKey:KEY_LONGITUDE];
    [aCoder encodeObject:self.city forKey:KEY_CITY];
}

@end
