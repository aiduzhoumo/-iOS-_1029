//
//  UIScrollView+MZLParallax.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-10-20.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIScrollView+MZLParallax.h"

#define KEY_PARALLAX_VIEW @"KEY_MZL_PARALLAX_VIEW"
#define KEY_PARALLAX_VIEW_HEIGHT @"KEY_PARALLAX_VIEW_HEIGHT"

@implementation UIScrollView (MZLParallax)

- (UIImageView *)mzl_createParallaxViewWithImage:(UIImage *)image height:(CGFloat)height {
    UIImageView *parallaxImageView = [[UIImageView alloc] init];
    parallaxImageView.image = image;
    [self mzl_attachParallaxView:parallaxImageView height:height];
    return parallaxImageView;
}

- (void )mzl_attachParallaxView:(UIView *)parallaxView height:(CGFloat)height {
    parallaxView.frame = CGRectMake(0, -1 * height, self.bounds.size.width, height);
    parallaxView.clipsToBounds = YES;
    [self addSubview:parallaxView];
    
    [self setProperty:KEY_PARALLAX_VIEW value:parallaxView];
    [self setProperty:KEY_PARALLAX_VIEW_HEIGHT value:@(height)];
    
    UIEdgeInsets newEdgeInsets = self.contentInset;
    newEdgeInsets.top = newEdgeInsets.top + height;
    self.contentInset = newEdgeInsets;
    self.contentOffset = CGPointMake(0, -1 * newEdgeInsets.top);
}

- (void)mzl_parallax_onScroll:(UIScrollView *)scrollView {
    UIView *parallaxView = [self getProperty:KEY_PARALLAX_VIEW];
    if (! parallaxView) {
        return;
    }
    
    CGFloat height = [[self getProperty:KEY_PARALLAX_VIEW_HEIGHT] floatValue];
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat insetsTop = scrollView.contentInset.top;
    CGFloat oriInsetsTop = insetsTop - height;
    CGFloat oriY = -1 * height;
    CGFloat oriEndY = oriY + height;
    CGFloat curVisibleY = yOffset + oriInsetsTop;
    CGRect f = parallaxView.frame;
    if (yOffset <= -1 * insetsTop) { // 下拉图片strech的效果
        f.origin.y = curVisibleY;
        f.size.height =  -1 * (yOffset + oriInsetsTop);
        parallaxView.frame = f;
        parallaxView.contentMode = UIViewContentModeScaleAspectFill;
    } else if (yOffset <= oriEndY){ // 上拉图片呈现视差的效果
        CGFloat parallaxFactor = 2.0;
        CGFloat deviation = curVisibleY - oriY;
        int deviationDelta = (int)(deviation / parallaxFactor);
        CGFloat newHeight = height - deviation + deviationDelta;
        CGFloat newY = oriEndY - newHeight;
        f.origin.y = newY;
        f.size.height =  newHeight;
        parallaxView.frame = f;
        parallaxView.contentMode = UIViewContentModeTop;
    }
}

@end
