//
//  MZLModelAuthorDetail.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-25.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelAuthorDetail.h"
#import "MZLModelImage.h"

@implementation MZLModelAuthorDetail

- (NSString *)coverUrl {
    return self.cover.fileUrl;
}

@end
