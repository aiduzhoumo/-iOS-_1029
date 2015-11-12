//
//  MZLMockData.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-2-10.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZLModelShortArticleComment.h"
#import "MZLModelShortArticle.h"
#import "MZLModelLocationExt.h"

@interface MZLMockData : NSObject

#pragma mark - short article related
+ (MZLModelShortArticleComment *)mockShortArticleComment;
+ (MZLModelShortArticle *)mockShortArticle;

#pragma mark - image
+ (NSString *)mockImageUrl;

#pragma mark - notification related
+ (void)mockArticleNotificationWithID:(NSInteger)identifier;
+ (void)mockLocationNotificationWithID:(NSInteger)identifier;
+ (void)mockNoticeNotificationWithID:(NSInteger)identifier;
+ (void)mockShortArticleNotificationWithID:(NSInteger)identifier;

@end
