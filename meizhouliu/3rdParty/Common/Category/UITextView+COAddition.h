//
//  UITextView+COAddition.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-4.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (COAddition)

/** the following methods should be invoked after setting its text */
- (CGSize)co_getFittingSize;
- (CGFloat)co_getFittingHeight;
- (CGFloat)co_getFittingWidth;

/** placeholder label */
- (void)co_addPlaceholderLabel:(UILabel *)lbl;
- (void)co_hidePlaceholderLabel;
- (void)co_checkPlaceholder;

@end
