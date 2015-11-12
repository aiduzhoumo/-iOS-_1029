//
//  UITableViewCell+COAddition.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-3.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (COAddition)

/** init with default style */
- (instancetype)co_initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)co_replaceDeleteControlWithImage:(UIImage *)image bgImage:(UIImage *)bgImage bgColor:(UIColor *)bgColor;

+ (NSString *)co_defaultReuseIdentifier;

@end
