//
//  MZLFilterItemWithLabel.m
//  mzl_mobile_ios
//
//  Created by race on 14/11/19.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFilterItemWithLabel.h"
#import <Masonry/Masonry.h>

@interface MZLFilterItemWithLabel(){
    UILabel *_lbl;
}

@end

@implementation MZLFilterItemWithLabel

- (void)initInternal {
    [self initUI];
    [self addTapGestureRecognizer:self action:@selector(toggleSelected)];
}

- (void)initUI {
    // 筛选项 大小
    [self.layer setBorderWidth:0.0];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@24);
    }];
    
    //筛选项 文字描述
    _lbl = [self createLabelWithParentView:self];
    _lbl.font = MZL_FONT(14);
    _lbl.textColor = colorWithHexString(@"#7f7f7f");
    [_lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - public

- (BOOL)isSelected {
    return _isSelected;
}

- (void)setSelected:(BOOL)flag {
    _isSelected = flag;
    [self modifyState];
    if (self.delegate) {
        [self.delegate onFilterOptionStateModified];
    }
}

- (void)setText:(NSString *)text {
    _lbl.text = [self formattedText:text];
}


- (void)toggleSelected {
//    _isSelected = ! _isSelected;
//    [self modifyState];
    BOOL flag = ! _isSelected;
    [self setSelected:flag];
}

#pragma mark - helper methods

- (void)modifyState {
    if (_isSelected) {
        _lbl.textColor = [UIColor whiteColor];
        self.backgroundColor = MZL_COLOR_YELLOW_FDD414();
        [self toRoundShape];
    } else {
        _lbl.textColor = colorWithHexString(@"#7f7f7f");
        self.backgroundColor = [UIColor clearColor];
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



@end
