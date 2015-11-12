//
//  UIScrollView+MZLParallax.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-10-20.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (MZLParallax)

- (UIImageView *)mzl_createParallaxViewWithImage:(UIImage *)image height:(CGFloat)height;
- (void )mzl_attachParallaxView:(UIView *)parallaxView height:(CGFloat)height;

- (void)mzl_parallax_onScroll:(UIScrollView *)scrollView;

@end
