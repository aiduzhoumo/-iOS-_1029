//
//  UITextView+COAddition.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-4.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "UITextView+COAddition.h"
#import "COUtils.h"
#import "NSObject+COAssociation.h"

#define PROP_PLACEHOLDER @"PROP_PLACEHOLDER"

@implementation UITextView (COAddition)

- (CGSize)co_getFittingSize {
    return [self sizeThatFits:self.bounds.size];
}

- (CGFloat)co_getFittingHeight {
    return ceilf([self co_getFittingSize].height);
}

- (CGFloat)co_getFittingWidth {
    return ceilf([self co_getFittingSize].width);
}

#pragma mark - placeholder related

- (void)co_addPlaceholderLabel:(UILabel *)lbl {
    [self setProperty:PROP_PLACEHOLDER value:lbl];
}

- (void)co_hidePlaceholderLabel {
    UILabel *lbl = [self getProperty:PROP_PLACEHOLDER];
    if (lbl) {
        lbl.hidden = YES;
    }
}

- (void)co_checkPlaceholder {
    UILabel *lbl = [self getProperty:PROP_PLACEHOLDER];
    if (lbl) {
        lbl.hidden = ! isEmptyString(self.text);
    }
}



@end
