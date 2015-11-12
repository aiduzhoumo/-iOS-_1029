//
//  COKeyboardToolbar.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-4.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CO_KB_TOOLBAR_HEIGHT 44.0

@interface COKeyboardToolbar : UIView

@property (nonatomic, readonly) UIView *topBorder;
@property (nonatomic, readonly) UIView *bottomBorder;

+ (instancetype)instance;
+ (instancetype)instanceWithHeight:(CGFloat)height;

@end
