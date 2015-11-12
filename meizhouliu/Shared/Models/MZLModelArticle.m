//
//  MZLModelArticle.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelArticle.h"
#import "MZLModelImage.h"

@implementation MZLModelArticle

- (NSString *)coverImageUrl {
    return self.coverImage.fileUrl;
}

@end
