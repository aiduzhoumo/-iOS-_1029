//
//  MZLShortArticleCommentResponse.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-2-4.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLShortArticleCommentResponse.h"

@implementation MZLShortArticleCommentResponse

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
    [mapping addRelationFromPath:@"comment" toProperty:@"comment" withMapping:[MZLModelShortArticleComment rkObjectMapping]];
}

@end
