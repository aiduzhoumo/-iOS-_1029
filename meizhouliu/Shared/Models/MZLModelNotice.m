//
//  MZLModelNotice.m
//  mzl_mobile_ios
//
//  Created by race on 14-9-3.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelNotice.h"

#define KEY_NOTICE_ID @"KEY_NOTICE_ID"
#define KEY_NOTICE_TITTLE @"KEY_NOTICE_TITTLE"
#define KEY_NOTICE_CONTENT @"KEY_NOTICE_CONTENT"
#define KEY_NOTICE_EDITTIME @"KEY_NOTICE_EDITTIME"
#define KEY_NOTICE_ISREAD @"KEY_NOTICE_ISREAD"

@implementation MZLModelNotice

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.identifier = [aDecoder decodeIntegerForKey:KEY_NOTICE_ID];
        self.title = [aDecoder decodeObjectForKey:KEY_NOTICE_TITTLE];
        self.content = [aDecoder decodeObjectForKey:KEY_NOTICE_CONTENT];
        self.editedDate = [aDecoder decodeObjectForKey:KEY_NOTICE_EDITTIME];
        
        self.isRead = [aDecoder decodeBoolForKey:KEY_NOTICE_ISREAD];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.identifier forKey:KEY_NOTICE_ID];
    [aCoder encodeObject:self.title forKey:KEY_NOTICE_TITTLE];
    [aCoder encodeObject:self.content forKey:KEY_NOTICE_CONTENT];
    [aCoder encodeObject:self.editedDate forKey:KEY_NOTICE_EDITTIME];
    
    [aCoder encodeBool:self.isRead forKey:KEY_NOTICE_ISREAD];
}

/** 是否是临时新增的noti */
- (BOOL)isEmptyNotice {
    if (isEmptyString(self.title) && isEmptyString(self.content) && isEmptyString(self.editedDate)) {
        return YES;
    }
    return NO;
}

- (void)update:(MZLModelNotice *)src {
    self.title = src.title;
    self.content = src.content;
    self.editedDate = src.editedDate;
}

#pragma mark - restkit mapping

+ (NSMutableDictionary *)attributeDictionary {
    NSMutableDictionary *attrDict = [super attributeDictionary];
    [attrDict fromPath:@"title" toProperty:@"title"];
    [attrDict fromPath:@"content_sanitize" toProperty:@"content"];
    [attrDict fromPath:@"edited_date" toProperty:@"editedDate"];
    return attrDict;
}

@end
