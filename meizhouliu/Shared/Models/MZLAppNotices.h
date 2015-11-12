//
//  MZLAppNotices.h
//  mzl_mobile_ios
//
//  Created by race on 14-9-5.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MZLModelNotice;

@interface MZLAppNotices : NSObject<NSCoding>

//@property (nonatomic , strong) NSMutableArray *notices;
//@property (nonatomic , copy) NSDate *lastRequestDate;

+ (void)loadNoticesFromCache;
//+ (void)removeNoticesFromPreference;
//- (void)saveInPreference;
//- (NSDate *)requestDate;
//- (NSInteger) numberOfUnreadNotices;
//- (void)setReadFlagWithSelectRowAtIndexPath:(NSInteger)index;

+ (NSInteger)unReadMessageCount;
+ (void)setReadFlagOnMessage:(MZLModelNotice *)target;
+ (NSArray *)allMessages;
+ (void)addMessages:(NSArray *)messages;
+ (void)addMessage:(MZLModelNotice *)target;
+ (NSDate *)lastRequestDate;
+ (void)setLastRequestDateToNow;
+ (void)removeMessage:(MZLModelNotice *)target;
+ (void)clearMessages;
+ (BOOL)hasMessage:(MZLModelNotice *)target;

@end
