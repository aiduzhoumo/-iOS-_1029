//
//  MZLModelArticleDetail.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-26.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelArticle.h"

@interface MZLModelArticleDetail : MZLModelArticle

@property (nonatomic, copy) NSString *articleUrl;
/** 用于分享 */
@property (nonatomic, copy) NSString *summary;
/** 用于个性化显示简介 */
@property (nonatomic, copy) NSString *fragment;
@property (nonatomic, strong) NSArray *trips;
@property (nonatomic, assign) NSInteger commentCount;

@end
