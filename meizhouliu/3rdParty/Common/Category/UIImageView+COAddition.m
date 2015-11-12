//
//  UIImageView+COAddition.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-2-15.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "UIImageView+COAddition.h"

@implementation UIImageView (COAddition)

- (void)co_animateFadeInImage:(UIImage *)image completion:(CO_BLOCK_VOID)completion {
    self.alpha = 0.3;
    self.image = image;
    [UIView animateWithDuration:0.8 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

@end
