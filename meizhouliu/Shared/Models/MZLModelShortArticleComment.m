//
//  MZLModelShortArticleComment.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-2-4.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLModelShortArticleComment.h"

@implementation MZLModelShortArticleComment

#pragma mark - override

- (NSMutableDictionary *)_toDictionary {
    NSMutableDictionary *dict = [super _toDictionary];
    NSString *content = self.content;
    if (! content) {
        content = @"";
    }
    [dict setKey:@"comment[content]" strValue:content];
    return dict;
}

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
    [mapping addRelationFromPath:@"user" toProperty:@"user" withMapping:[MZLModelUser rkObjectMapping]];
}

+ (NSMutableArray *)attrArray {
    return [[super attrArray] co_addObject:@"content"];
}

+ (NSMutableDictionary *)attributeDictionary {
    NSMutableDictionary *dict = [super attributeDictionary];
    [dict fromPath:@"created_at" toProperty:@"publishedAt"];
    return dict;
}

- (NSString *)publishedTimeStr {
    return co_getTimeDiffString(self.publishedAt);
}

- (BOOL)canEdit {
    return [MZLSharedData isAppUserLogined] && [MZLSharedData appUserId] == self.user.identifier;
}

@end
