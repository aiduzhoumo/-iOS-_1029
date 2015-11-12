//
//  MZLShortArticleResponse.h
//  mzl_mobile_ios
//
//  Created by race on 15/1/22.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLServiceResponseObject.h"
#import "MZLModelShortArticle.h"

@interface MZLShortArticleResponse : MZLServiceResponseObject

@property (strong, nonatomic) MZLModelShortArticle *article;

@end
