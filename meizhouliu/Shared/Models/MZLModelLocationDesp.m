//
//  MZLModelLocationDesp.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-26.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLModelLocationDesp.h"

@implementation MZLModelLocationDesp

+ (NSMutableArray *)attrArray {
    return [[super attrArray] co_addObject:@"content"];
}

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
    [mapping addRelationFromPath:@"user" toProperty:@"user" withMapping:[MZLModelUser rkObjectMapping]];
}

- (NSString *)userImageUrl {
    return self.user.headerImage.fileUrl;
}

- (NSString *)userName {
    return self.user.nickName;
}

@end
