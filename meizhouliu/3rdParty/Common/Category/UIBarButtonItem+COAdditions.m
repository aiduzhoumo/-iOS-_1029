//
//  UIBarButtonItem+COAdditions.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-20.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIBarButtonItem+COAdditions.h"

@implementation UIBarButtonItem (COAdditions)

+ (UIBarButtonItem *)itemWithSize:(CGSize)size bgImageName:(NSString *)bgImageName target:(id)target action:(SEL)action {
    UIButton *button = [self buttonWithSize:size target:target action:action];
    [button setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithCustomView:button];
    return btn;
}

+ (UIBarButtonItem *)itemWithSize:(CGSize)size imageName:(NSString *)imageName target:(id)target action:(SEL)action {
    return [self itemWithSize:size image:[UIImage imageNamed:imageName] target:target action:action];
}

+ (UIBarButtonItem *)itemWithSize:(CGSize)size image:(UIImage *)image target:(id)target action:(SEL)action {
    UIButton *button = [self buttonWithSize:size target:target action:action];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithCustomView:button];
    return btn;
}


+ (UIButton *)buttonWithSize:(CGSize)size target:(id)target action:(SEL)action {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
