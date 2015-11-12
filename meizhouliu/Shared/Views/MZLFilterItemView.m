//
//  MZLFilterItemView.m
//  Test
//
//  Created by Whitman on 14-9-5.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFilterItemView.h"
#import "WeView.h"
#import "UIView+COAdditions.h"

@interface MZLFilterItemView() {
    UILabel *_lbl;
    BOOL _isSelected;
}

@end

@implementation MZLFilterItemView

- (void)initInternal {
    [self setFixedDesiredSize:CGSizeMake(70.0, 36.0)];
    [self.layer setCornerRadius:18.0];
    [self.layer setBorderColor:[MZL_COLOR_BLACK_999999() CGColor]];
    _lbl = [[UILabel alloc] init];
    _lbl.font = MZL_FONT(15.0);
    _isSelected = NO;
    [self modifyState];
    [self addTapGestureRecognizer:self action:@selector(toggleSelected)];
    [[[self addSubviewsWithVerticalLayout:@[_lbl]] setHMargin:10.0] setVMargin:10.0];
}

- (void)toggleSelected {
    _isSelected = ! _isSelected;
    [self modifyState];
    if (self.delegate) {
        [self.delegate onFilterOptionStateModified];
    }
}

- (void)modifyState {
    if (_isSelected) {
        _lbl.textColor = [UIColor whiteColor];
        self.backgroundColor = MZL_COLOR_GREEN_85DDCC();
        [self.layer setBorderWidth:0.0];
    } else {
        _lbl.textColor = MZL_COLOR_BLACK_999999();
        self.backgroundColor = [UIColor clearColor];
        [self.layer setBorderWidth:0.0];
    }
}

- (NSString *)formattedText:(NSString *)text {
    if (text.length == 2) {
        NSString *firstChar = [text substringToIndex:1];
        NSString *secondChar = [text substringWithRange:NSMakeRange(1, 1)];
        return [NSString stringWithFormat:@"%@   %@", firstChar, secondChar];
    }
    return text;
}

#pragma mark - public

- (BOOL)isSelected {
    return _isSelected;
}

- (void)setSelected:(BOOL)flag {
    _isSelected = flag;
    [self modifyState];
}

- (void)setText:(NSString *)text {
    _lbl.text = [self formattedText:text];
}

@end
