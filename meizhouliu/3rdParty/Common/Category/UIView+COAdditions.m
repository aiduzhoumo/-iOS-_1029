//
//  UIView+COAdditions.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-17.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIView+COAdditions.h"
#import "NSObject+COAssociation.h"

@implementation UIView (COAdditions)

+ (id)viewFromNib:(NSString *)nibFileName  {
    return [[NSBundle mainBundle] loadNibNamed:nibFileName owner:nil options:nil][0];
}

- (void)toRoundShape {
    CGFloat diameter = self.bounds.size.height;
    if (diameter <= 0) {
        diameter = self.bounds.size.width;
        if (diameter <= 0) {
            return;
        }
    }
    [self co_toRoundShapeWithDiameter:diameter];
}

- (void)co_toRoundShapeWithDiameter:(CGFloat)diameter {
    [self.layer setCornerRadius:diameter / 2.0];
    [self.layer setMasksToBounds:YES];
}

#pragma mark - tap gesture

- (UITapGestureRecognizer *)addTapGestureRecognizer:(id)target action:(SEL)selector {
    // Keep in mind that "target" here is not strongly maintained
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:tap];
    return tap;
}

- (UITapGestureRecognizer *)addTapGestureRecognizerToDismissKeyboard {
    return [self addTapGestureRecognizer:self action:@selector(dismissKeyboard)];
}

- (void)dismissKeyboard {
    [self endEditing:YES];
}

//- (CGFloat)getHeight {
//    return self.bounds.size.height;
//}
//
//- (void)setHeight:(CGFloat)height {
//    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, height);
//}

#pragma mark - view creation

+ (id)createView:(Class)viewClass parent:(UIView *)parent {
    id view = [[viewClass alloc] init];
    [parent addSubview:view];
    return view;
}

- (id)createSubview:(Class)viewClass {
    return [UIView createView:viewClass parent:self];
}

#pragma mark - animation

#define CO_VIEW_ANIMATION_DEFAULT_DURATION 0.3

- (void)co_animateToY:(CGFloat)destY completionBlock:(void (^)(void))completionBlock {
    [self co_animateToY:destY duration:CO_VIEW_ANIMATION_DEFAULT_DURATION completionBlock:completionBlock];
}

- (void)co_animateToY:(CGFloat)destY duration:(CGFloat)duration completionBlock:(void (^)(void))completionBlock {
    if (destY == self.frame.origin.y) {
        return;
    }
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.frame;
        frame.origin.y = destY;
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (completionBlock) {
            completionBlock();
        }
    }];
}

/** scale以后返回原状态 */
- (void)co_animation_layerScale:(CGFloat)scaleFactor delegate:(id)delegate {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scaleFactor, scaleFactor, scaleFactor)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [animation setDuration:0.3];
    [animation setAutoreverses:YES];
    if (delegate) {
        animation.delegate = delegate;
    }
    [self.layer addAnimation:animation forKey:@"transform"];
}

#pragma mark - misc

- (CGFloat)co_fittingHeight {
    return [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (CGFloat)co_fittingWidth {
    return [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
}

- (CGSize)co_fittingSize {
    return [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

- (UIView *)co_preSiblingView {
    if (self.superview) {
        NSInteger index = [self.superview.subviews indexOfObject:self];
        if (index > 0) {
            return self.superview.subviews[index - 1];
        }
    }
    return nil;
}

#pragma mark - autolayout

#define CO_VIEW_LAYOUT_CONS_KEY @"CO_VIEW_LAYOUT_CONS_KEY_%d"

- (NSString *)co_constraintKey:(NSLayoutAttribute)attr {
    return [NSString stringWithFormat:CO_VIEW_LAYOUT_CONS_KEY, (NSInteger)attr];
}

- (NSLayoutConstraint *)co_findConstraintWithAttr:(NSLayoutAttribute)attr {
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if ((constraint.firstItem == self && constraint.firstAttribute == attr)
            || (constraint.secondItem == self && constraint.secondAttribute == attr)) {
            return constraint;
        }
    }
    return nil;
}

- (void)co_enableConstraint:(NSLayoutAttribute)attr {
    NSLayoutConstraint *constraint = [self co_findConstraintWithAttr:attr];
    if (constraint) {
        NSString *key = [self co_constraintKey:attr];
        NSNumber *value = [self getProperty:key];
        if (value) {
            if (constraint.constant == [value integerValue]) {
                return;
            }
            constraint.constant = [value integerValue];
        }
    }
}

- (void)co_disableConstraint:(NSLayoutAttribute)attr {
    NSLayoutConstraint *constraint = [self co_findConstraintWithAttr:attr];
    if (constraint) {
        NSString *key = [self co_constraintKey:attr];
        if (constraint.constant == 0) {
            return;
        }
        [self setProperty:key value:@(constraint.constant)];
        constraint.constant = 0;
    }
}

#pragma mark - layout related

- (UIView *)co_pos_centerParent {
    if (! self.superview) {
        return self;
    }
    if (CGSizeEqualToSize(self.bounds.size, CGSizeZero) || CGSizeEqualToSize(self.superview.bounds.size, CGSizeZero)) {
        return self;
    }
    CGPoint center;
    CGRect superviewBounds = self.superview.bounds;
    center.x = superviewBounds.size.width / 2.0 + superviewBounds.origin.x;
    center.y = self.superview.bounds.size.height / 2.0 + superviewBounds.origin.y;
    self.center = center;
    return self;
}

@end
