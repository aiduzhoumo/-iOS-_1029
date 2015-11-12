//
//  UIStoryboard+COAddition.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-19.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (COAddition)

/** 会对storyboard做一个缓存 */
+ (UIStoryboard *)co_storyboardWithName:(NSString *)name;

@end
