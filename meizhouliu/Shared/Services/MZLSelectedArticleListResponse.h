//
//  MZLSelectedArticleListResponse.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-6-13.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZLSelectedArticleListResponse : NSObject

/** 如果选中的目的地没有文章，将返回系统精选文章列表 */
@property (nonatomic, assign) BOOL isSystemArticles;
/** match MZLArticleModelObject */
@property (nonatomic, strong) NSArray *articles;

@end
