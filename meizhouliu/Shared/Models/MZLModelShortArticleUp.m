//
//  MZLModelShortArticleUp.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-27.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLModelShortArticleUp.h"

@implementation MZLModelShortArticleUp

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
    [mapping addRelationFromPath:@"user" toProperty:@"user" withMapping:[MZLModelUser rkObjectMapping]];
}

@end
