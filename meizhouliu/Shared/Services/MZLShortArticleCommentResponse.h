//
//  MZLShortArticleCommentResponse.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-2-4.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLServiceResponseObject.h"
#import "MZLModelShortArticleComment.h"

@interface MZLShortArticleCommentResponse : MZLServiceResponseObject

@property (nonatomic, strong) MZLModelShortArticleComment *comment;

@end
