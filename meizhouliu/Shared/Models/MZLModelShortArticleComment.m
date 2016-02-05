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
    NSString *user_nickname = self.user_nickname;
    if (! user_nickname) {
        user_nickname = @"";
    }
    NSString *reply_id = self.reply_id;
    if (! reply_id) {
        reply_id = @"";
    }
    [dict setKey:@"comment[content]" strValue:content];
    [dict setKey:@"comment[user_nickname]" strValue:user_nickname];
    [dict setKey:@"comment[reply_id]" strValue:reply_id];
    return dict;
}

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
    [mapping addRelationFromPath:@"user" toProperty:@"user" withMapping:[MZLModelUser rkObjectMapping]];
    [mapping addRelationFromPath:@"reply_user" toProperty:@"reply_user" withMapping:[MZLModelUser rkObjectMapping]];
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
