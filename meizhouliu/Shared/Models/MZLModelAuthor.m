//
//  MZLModelAuthor.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelAuthor.h"
#import "MZLModelImage.h"

@implementation MZLModelAuthor

- (NSString *)photoUrl {
    return self.photo.fileUrl;
}

@end
