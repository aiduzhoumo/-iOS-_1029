//
//  MZLMyTopBar.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-12.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLMyAuthorTopBar.h"

@implementation MZLMyAuthorTopBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - override

- (NSArray *)array:(NSArray *)array addFirstObject:(id)object {
    NSMutableArray *result = [NSMutableArray arrayWithObject:object];
    [result addObjectsFromArray:array];
    return result;
}

- (NSArray *)tabNames {
    return [self array:[super tabNames] addFirstObject:@"去过"];
}

- (NSArray *)tabIcons {
    return [self array:[super tabIcons] addFirstObject:@"tab_my_article"];
}

- (NSArray *)tabSelectedIcons {
    return [self array:[super tabSelectedIcons] addFirstObject:@"tab_my_article_sel"];
}

- (NSArray *)tabIndexes {
    return [self array:[super tabIndexes] addFirstObject:@(MZL_MY_ARTICLE_INDEX)];
}

@end
