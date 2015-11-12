//
//  UIImageView+COAddition.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-2-15.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "COMacros.h"

@interface UIImageView (COAddition)

- (void)co_animateFadeInImage:(UIImage *)image completion:(CO_BLOCK_VOID)completion;

@end
