//
//  MZLModelUserFavoredArticle.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-4.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"

@class MZLModelArticle;

@interface MZLModelUserFavoredArticle : MZLModelObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) MZLModelArticle *article;
@property (nonatomic, assign) NSInteger articleId;

@end
