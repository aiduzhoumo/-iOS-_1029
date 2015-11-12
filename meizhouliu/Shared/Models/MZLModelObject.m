//
//  MZLModelObject.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"

@implementation MZLModelObject

+ (NSMutableDictionary *)attributeDictionary {
    return [[super attributeDictionary] fromPath:@"id" toProperty:@"identifier"];
}

#pragma mark - coping

- (id)copyWithZone:(NSZone *)zone {
    MZLModelObject *copied = [[[self class] allocWithZone:zone] init];
    copied.identifier = self.identifier;
    return copied;
}

#pragma mark - coding

#define KEY_CODING_IDENTIFIER @"KEY_CODING_IDENTIFIER"

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.identifier = [[aDecoder decodeObjectForKey:KEY_CODING_IDENTIFIER] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(self.identifier) forKey:KEY_CODING_IDENTIFIER];
}

@end