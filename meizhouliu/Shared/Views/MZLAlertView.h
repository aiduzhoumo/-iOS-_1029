//
//  MZLAlertView.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-4.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZLAlertView : UIView

+ (void)showWithImageNamed:(NSString *)image text:(NSString *)text;
+ (void)showWithImage:(UIImage *)image text:(NSString *)text viewForBlur:(UIView *)viewForBlur;

@end
