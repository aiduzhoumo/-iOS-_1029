//
//  UIView+COPopAdditions.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-13.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class POPSpringAnimation;

@interface UIView (COPopAdditions)

- (POPSpringAnimation *)co_animateFrameX:(CGFloat)toValue;
- (POPSpringAnimation *)co_animateFrameX:(CGFloat)toValue key:(NSString *)key;
- (POPSpringAnimation *)co_animateFrameY:(CGFloat)toValue key:(NSString *)key;
- (POPSpringAnimation *)co_animateCenter:(CGPoint)toValue;

- (POPSpringAnimation *)co_scaleAnimation:(CGFloat)scaleFactor;

@end
