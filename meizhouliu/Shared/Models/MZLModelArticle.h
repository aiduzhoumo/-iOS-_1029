//
//  MZLModelArticle.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZLModelObject.h"

@class MZLModelLocation, MZLModelAuthor, MZLModelImage;

@interface MZLModelArticle : MZLModelObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *span;
@property (nonatomic, copy) NSString *tags;

@property(nonatomic, strong) MZLModelLocation *destination;
@property(nonatomic, strong) MZLModelAuthor *author;
@property (nonatomic, strong) MZLModelImage *coverImage;

/** 是否为推精文章 */
@property (nonatomic, assign) BOOL essence;

@property(nonatomic, readonly) NSString *coverImageUrl;

@end
