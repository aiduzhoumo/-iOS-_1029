//
//  MZLUserFavoredArticleResponse.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-4.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZLServiceResponseObject.h"

@class MZLModelUserFavoredArticle;

@interface MZLUserFavoredArticleResponse : MZLServiceResponseObject

@property (nonatomic, strong) MZLModelUserFavoredArticle *userFavoredArticle;

@end
