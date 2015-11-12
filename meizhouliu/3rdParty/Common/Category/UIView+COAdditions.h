//
//  UIView+COAdditions.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-17.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (COAdditions)

/** fitting height using UILayoutFittingCompressedSize */
@property (nonatomic, readonly) CGFloat co_fittingHeight;
@property (nonatomic, readonly) CGFloat co_fittingWidth;
@property (nonatomic, readonly) CGSize co_fittingSize;

+ (id)viewFromNib:(NSString *)nibFileName;

- (UITapGestureRecognizer *)addTapGestureRecognizer:(id)target action:(SEL)selector;
- (UITapGestureRecognizer *)addTapGestureRecognizerToDismissKeyboard;

- (void)toRoundShape;
- (void)co_toRoundShapeWithDiameter:(CGFloat)diameter;

+ (id)createView:(Class)viewClass parent:(UIView *)parent;
- (id)createSubview:(Class)viewClass;

/** for non-autolayout */
- (void)co_animateToY:(CGFloat)destY completionBlock:(void (^)(void))completionBlock;
- (void)co_animation_layerScale:(CGFloat)scaleFactor delegate:(id)delegate;

- (UIView *)co_preSiblingView;

- (void)co_enableConstraint:(NSLayoutAttribute)attr;
- (void)co_disableConstraint:(NSLayoutAttribute)attr;

- (UIView *)co_pos_centerParent;

@end
