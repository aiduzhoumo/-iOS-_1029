//
//  UIBarButtonItem+COAdditions.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-20.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (COAdditions)

+ (UIBarButtonItem *)itemWithSize:(CGSize)size bgImageName:(NSString *)bgImageName target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithSize:(CGSize)size imageName:(NSString *)imageName target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithSize:(CGSize)size image:(UIImage *)image target:(id)target action:(SEL)action;


@end
