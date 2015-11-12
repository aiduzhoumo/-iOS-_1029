//
//  MZLModelComment.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-25.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelComment.h"
#import "MZLModelUser.h"

@implementation MZLModelComment

#pragma mark - restkit mapping

+ (NSMutableArray *)attrArray {
    return [[super attrArray] addArray:@[@"content"]];
}

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
    [mapping addRelationWithPath:@"user" andMapping:[MZLModelUser rkObjectMapping]];
}

#pragma mark - dictionary

- (NSMutableDictionary *)_toDictionary {
    return [[super _toDictionary] setKey:@"comment[content]" strValue:self.content];
}

@end
