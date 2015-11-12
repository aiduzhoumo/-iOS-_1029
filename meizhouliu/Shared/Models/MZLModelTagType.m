//
//  MZLModelTagType.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-6-6.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelTagType.h"
#import "MZLModelTag.h"

@implementation MZLModelTagType

+ (NSMutableArray *)attrArray {
    return [[super attrArray] co_addObject:@"name"];
}

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
    [mapping addRelationFromPath:@"tags" toProperty:@"tagsArray" withMapping:[MZLModelTag rkObjectMapping]];
}

+ (instancetype)tagTypeWithName:(NSString *)name tagsStrArray:(NSArray *)tagsStrArray {
    MZLModelTagType *tagType = [[MZLModelTagType alloc] init];
    tagType.name = name;
    NSMutableArray *tagsArray = co_emptyMutableArray();
    for (NSString *tagsStr in tagsStrArray) {
        MZLModelTag *tag = [[MZLModelTag alloc] init];
        tag.name = tagsStr;
        [tagsArray addObject:tagsStr];
    }
    tagType.tagsArray = tagsArray;
    return tagType;
}

#pragma mark - coding

#define KEY_NAME @"KEY_NAME"
#define KEY_TAGS @"KEY_TAGS"

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.name = [aDecoder decodeObjectForKey:KEY_NAME];
        self.tagsArray = [aDecoder decodeObjectForKey:KEY_TAGS];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.name forKey:KEY_NAME];
    [aCoder encodeObject:self.tagsArray forKey:KEY_TAGS];
}

#define MZL_KEY_TAG_TYPES @"MZL_KEY_TAG_TYPES"

+ (void)saveInPreference:(NSArray *)tagTypes {
    [COPreferences archiveUserPreference:tagTypes forKey:MZL_KEY_TAG_TYPES];
}

+ (NSArray *)cachedTagTypes {
    return [COPreferences getCodedUserPreference:MZL_KEY_TAG_TYPES];
}

@end
