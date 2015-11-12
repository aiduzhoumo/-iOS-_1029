//
//  MZLShortArticleUpResponse.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-29.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLShortArticleUpResponse.h"

@implementation MZLShortArticleUpResponse

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
    [mapping addRelationFromPath:@"up" toProperty:@"up" withMapping:[MZLModelShortArticleUp rkObjectMapping]];
}

@end
