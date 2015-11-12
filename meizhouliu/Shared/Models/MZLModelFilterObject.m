//
//  MZLModelFilterObject.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-2.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelFilterObject.h"

@implementation MZLModelFilterObject

+ (NSMutableDictionary *)attributeDictionary {
    return [[super attributeDictionary] fromPath:@"name" toProperty:@"displayName"];
}

#pragma mark - coding

#define KEY_ITEM_TYPE @"KEY_ITEM_TYPE"
#define KEY_DISPLAY_NAME @"KEY_DISPLAY_NAME"
#define KEY_DISPLAY_IMAGE @"KEY_DISPLAY_IMAGE"

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.itemType = [aDecoder decodeIntForKey:KEY_ITEM_TYPE];
        self.displayName = [aDecoder decodeObjectForKey:KEY_DISPLAY_NAME];
        self.imageName = [aDecoder decodeObjectForKey:KEY_DISPLAY_IMAGE];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:self.itemType forKey:KEY_ITEM_TYPE];
    [aCoder encodeObject:self.displayName forKey:KEY_DISPLAY_NAME];
    [aCoder encodeObject:self.imageName forKey:KEY_DISPLAY_IMAGE];
}

#pragma mark - coping

- (id)copyWithZone:(NSZone *)zone {
    MZLModelFilterObject *copied = [super copyWithZone:zone];
    copied.itemType = self.itemType;
    copied.displayName = self.displayName;
    copied.imageName = self.imageName;
    return copied;
}

@end
