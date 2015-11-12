//
//  MZLAppNotices.m
//  mzl_mobile_ios
//
//  Created by race on 14-9-5.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLAppNotices.h"
#import "MZLModelNotice.h"
#import <IBMessageCenter.h>

#define KEY_APP_MESSAGES @"KEY_APP_NOTICES"

@interface MZLAppNotices () {
    NSDate *_lastRequestDate;
}

@property (nonatomic, strong) NSMutableArray *messages;

@end

static MZLAppNotices *_sharedInstance;

@implementation MZLAppNotices

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.messages = [aDecoder decodeObjectForKey:KEY_APP_MESSAGES];
//        self.lastRequestDate = [aDecoder decodeObjectForKey:KEY_NOTICES_LAST_REQUEST_DATE];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.messages forKey:KEY_APP_MESSAGES];

//    if (self.messages != nil) {
////        [aCoder encodeObject:self.lastRequestDate forKey:KEY_NOTICES_LAST_REQUEST_DATE];
//    }
}

#pragma mark - requestDate

- (NSDate *)lastRequestDate {
    if (! _lastRequestDate) {
        _lastRequestDate = [COPreferences getUserPreference:MZL_KEY_CACHED_APP_MESSAGE_REQUEST_DATE];
        if (! _lastRequestDate) {
            // 首次request，设为昨天以便有消息数据
            _lastRequestDate = [NSDate date];
            return yesterday();
        }
    }
    return _lastRequestDate;
}

- (void)setLastRequestDate:(NSDate *)lastRequestDate {
    _lastRequestDate = lastRequestDate;
    [COPreferences setUserPreference:lastRequestDate forKey:MZL_KEY_CACHED_APP_MESSAGE_REQUEST_DATE];
}

#pragma mark - count of unread notices

- (NSInteger)numberOfUnreadMessages {
    NSInteger countOfUnreadMessages = 0;
    for (MZLModelNotice *message in self.messages) {
        if (! [message isEmptyNotice] && ! message.isRead) {
            countOfUnreadMessages ++;
        }
    }
    return countOfUnreadMessages;
}

#pragma mark - cache with NSUserDefaults

+ (void)loadNoticesFromCache {
    _sharedInstance = [COPreferences getCodedUserPreference:MZL_KEY_CACHED_APP_MESSAGES];
    if (! _sharedInstance) {
        _sharedInstance = [[MZLAppNotices alloc] init];
        _sharedInstance.messages = [NSMutableArray array];
    }
}

- (void)saveInPreference {
    [COPreferences archiveUserPreference:self forKey:MZL_KEY_CACHED_APP_MESSAGES];
}

#pragma mark - instance methods

- (void)onMessagesUpdated {
    [_sharedInstance saveInPreference];
    updateAppBadgeWithUnreadNotiCount();
    [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_APP_MESSAGE_UPDATED];
}

- (MZLModelNotice *)getMessage:(MZLModelNotice *)target {
    for (MZLModelNotice *message in self.messages) {
        if (target.identifier == message.identifier) {
            return message;
        }
    }
    return nil;
}

- (void)removeMessage:(MZLModelNotice *)target {
    MZLModelNotice *message = [self getMessage:target];
    if (message) {
        [self.messages removeObject:message];
        [self onMessagesUpdated];
    }
}

- (void)removeAllMessages {
    if (self.messages.count > 0) {
        [self.messages removeAllObjects];
        [self onMessagesUpdated];
    }
}

- (BOOL)containsMessage:(MZLModelNotice *)target {
    return [self getMessage:target] != nil;
}

- (void)addMessages:(NSArray *)messages {
    BOOL changeFlag = NO;
    for (MZLModelNotice *message in messages) {
        if ([self _addOrUpdateMessage:message]) {
            changeFlag = YES;
        }
    }
    if (changeFlag) {
        [self onMessagesUpdated];
    }
}

- (void)addMessage:(MZLModelNotice *)target {
    if ([self _addOrUpdateMessage:target]) {
        [self onMessagesUpdated];
    }
}

/** return YES - insert a new message; return NO - update a temp message */
- (BOOL)_addOrUpdateMessage:(MZLModelNotice *)target {
    MZLModelNotice *message = [self getMessage:target];
    if (message) {
        [message update:target];
        return NO;
    } else {
        [self.messages insertObject:target atIndex:0];
        return YES;
    }
}

- (void)setReadFlagOnMessage:(MZLModelNotice *)target {
    MZLModelNotice *message = [self getMessage:target];
    if (message) {
        message.isRead = YES;
        [self onMessagesUpdated];
    }
}

#pragma mark - misc

+ (NSDate *)lastRequestDate {
    return _sharedInstance.lastRequestDate;
}

+ (void)setLastRequestDateToNow {
    [_sharedInstance setLastRequestDate:[NSDate date]];
}

+ (NSArray *)allMessages {
    NSArray *result = [_sharedInstance.messages select:^BOOL(MZLModelNotice *message) {
        return ![message isEmptyNotice];
    }];
    return result;
}

+ (NSInteger)unReadMessageCount {
    return [_sharedInstance numberOfUnreadMessages];
}

+ (void)removeMessage:(MZLModelNotice *)target {
    [_sharedInstance removeMessage:target];
}

+ (void)clearMessages {
    [_sharedInstance removeAllMessages];
}

+ (void)addMessages:(NSArray *)messages {
    [_sharedInstance addMessages:messages];
}

+ (void)addMessage:(MZLModelNotice *)target {
    [_sharedInstance addMessage:target];
}

+ (void)setReadFlagOnMessage:(MZLModelNotice *)target {
    [_sharedInstance setReadFlagOnMessage:target];
}

+ (BOOL)hasMessage:(MZLModelNotice *)target {
    return [_sharedInstance containsMessage:target];
}


@end
