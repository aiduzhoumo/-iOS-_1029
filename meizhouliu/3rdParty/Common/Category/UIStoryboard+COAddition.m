//
//  UIStoryboard+COAddition.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-19.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIStoryboard+COAddition.h"

@implementation UIStoryboard (COAddition)

static NSMutableDictionary *_co_storyboards;

+ (UIStoryboard *)co_storyboardWithName:(NSString *)name {
    if (! _co_storyboards) {
        _co_storyboards = [NSMutableDictionary dictionary];
    }
    UIStoryboard *storyboard = _co_storyboards[name];
    if (! storyboard) {
        storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
        _co_storyboards[name] = storyboard;
    }
    return storyboard;
}

@end
