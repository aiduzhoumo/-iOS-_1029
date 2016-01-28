//
//  MZLModelShortArticleComment.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-2-4.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"
#import "MZLModelUser.h"

@interface MZLModelShortArticleComment : MZLModelObject

@property (nonatomic, strong) MZLModelUser *user;
@property (nonatomic, strong) MZLModelUser *reply_user;
@property (nonatomic, assign) double publishedAt;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, readonly) NSString *publishedTimeStr;

@property (nonatomic, copy) NSString *user_nickname;
@property (nonatomic, copy) NSString *reply_id;

/** if the user who posts the comment is the current logined user, this comment can be edited */
@property (nonatomic, readonly) BOOL canEdit;

@end
