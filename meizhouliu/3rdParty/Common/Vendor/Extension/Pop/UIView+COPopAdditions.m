//
//  UIView+COPopAdditions.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-13.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIView+COPopAdditions.h"
#import <pop/POP.h>

#define DEFAULT_CO_ANIMATION_NAME @"co_pop_animation"

@implementation UIView (COPopAdditions)

- (POPSpringAnimation *)co_spring_animateWithPropertyNamed:(NSString *)propName toValue:(NSValue *)toValue key:(NSString *)key {
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:propName];
    animation.toValue = toValue;
    animation.springBounciness = 0;
    NSString *tempKey = key ? key : DEFAULT_CO_ANIMATION_NAME;
    [self pop_addAnimation:animation forKey:tempKey];
    return animation;
}

- (POPSpringAnimation *)co_animateFrameX:(CGFloat)toValue {
    return [self co_animateFrameX:toValue key:nil];
}

- (POPSpringAnimation *)co_animateFrameX:(CGFloat)toValue key:(NSString *)key {
    // 忽略<1的移动
    NSInteger originX = (NSInteger)self.frame.origin.x;
    NSInteger intToValue = (NSInteger)toValue;
    if (originX == intToValue) {
        // no need to animate;
        return nil;
    }
    NSValue *toValueFrame = [NSValue valueWithCGRect:CGRectMake(toValue, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height)];
    return [self co_spring_animateWithPropertyNamed:kPOPViewFrame toValue:toValueFrame key:key];
}

- (POPSpringAnimation *)co_animateFrameY:(CGFloat)toValue key:(NSString *)key {
    // 忽略<1的移动
    NSInteger originY = (NSInteger)self.frame.origin.y;
    NSInteger intToValue = (NSInteger)toValue;
    if (originY == intToValue) {
        // no need to animate;
        return nil;
    }
    NSValue *toValueFrame = [NSValue valueWithCGRect:CGRectMake(self.frame.origin.x, toValue, self.bounds.size.width, self.bounds.size.height)];
    return [self co_spring_animateWithPropertyNamed:kPOPViewFrame toValue:toValueFrame key:key];
}

- (POPSpringAnimation *)co_animateCenter:(CGPoint)toValue {
    NSValue *toValueCenter = [NSValue valueWithCGPoint:toValue];
    return [self co_spring_animateWithPropertyNamed:kPOPViewCenter toValue:toValueCenter key:nil];
}

- (POPSpringAnimation *)co_scaleAnimation:(CGFloat)scaleFactor {
    POPSpringAnimation *animation = [POPSpringAnimation animation];
    animation.property = [POPAnimatableProperty propertyWithName:kPOPLayerScaleXY];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(scaleFactor, scaleFactor)];
    animation.springBounciness = 4.0;
    animation.springSpeed = 15.0;
    animation.autoreverses = YES;
    return animation;
}

@end
