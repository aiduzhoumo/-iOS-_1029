//
//  MZLModelTag.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-3-4.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLModelTag.h"

@implementation MZLModelTag

#define KEY_NAME @"KEY_NAME"

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.name = [aDecoder decodeObjectForKey:KEY_NAME];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.name forKey:KEY_NAME];
}

#pragma mark - override

+ (NSMutableArray *)attrArray {
    return [[super attrArray] co_addObject:@"name"];
}

@end
