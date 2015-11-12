//
//  MZLShortArticleResponse.m
//  mzl_mobile_ios
//
//  Created by race on 15/1/22.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLShortArticleResponse.h"

@implementation MZLShortArticleResponse

#pragma mark - restkit mapping

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
     [mapping addRelationFromPath:@"short_article" toProperty:@"article" withMapping:[MZLModelShortArticle rkObjectMapping]];
}

@end
