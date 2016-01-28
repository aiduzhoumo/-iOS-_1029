//
//  MZLModelUser.h
//  mzl_mobile_ios
//
//  Created by alfred on 14-7-31.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZLModelObject.h"
#import "MZLModelImage.h"

typedef NS_ENUM(NSInteger, MZLModelUserType) {
    MZLModelUserTypeNormal = 0,
    MZLModelUserTypeAuthor  = 10,
    MZLModelUserTypeSignedAuthor  = 100
};

@class MZLModelAuthor,MZLModelShortArticle,MZLShortArticlesModel;

@interface MZLModelUser : MZLModelObject

@property (nonatomic , copy) NSString *nickName;
@property (nonatomic , strong) MZLModelImage *headerImage;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) MZLModelUserType level;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *bind;

@property (nonatomic, copy) NSString *introduction;
@property (nonatomic , strong) MZLModelImage *cover;
@property (nonatomic, copy) NSString *tags;

@property (nonatomic, readonly) NSString *photoUrl;
@property (nonatomic, readonly) NSString *coverUrl;
@property (nonatomic, readonly) NSString *name;

@property (nonatomic, copy) NSString *followees_count;
@property (nonatomic, copy) NSString *followers_count;

@property (nonatomic, strong) NSArray *short_articles;

/** 界面辅助字段，当前用户是否已关注该短文作者*/
@property (nonatomic, assign) BOOL isAttentionForCurrentUser;

- (MZLModelAuthor *)toAuthor;
- (BOOL)isSignedAuthor;

@end
