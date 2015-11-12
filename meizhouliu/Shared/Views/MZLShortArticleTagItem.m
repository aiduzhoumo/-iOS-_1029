//
//  MZLShortArticleTagItem.m
//  mzl_mobile_ios
//
//  Created by race on 15/1/12.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//
#import "MZLShortArticleTagItem.h"

#import "UIView+MZLAdditions.h"
#import "UILabel+COAdditions.h"

#define MZL_TAGS_LABEL_WIDTH CO_SCREEN_WIDTH - 72

@interface MZLShortArticleTagItem ()

@property (nonatomic,weak) UIImageView *imgTag;

@end

@implementation MZLShortArticleTagItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initInternal];
    }
    return self;
}


- (void)initInternal {
//    self.contentView = [self createSubView];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@23);
    }];
    [self setBackgroundColor:colorWithHexString(@"#b0b0b0")];
    [self addTapGestureRecognizer:self action:@selector(onItemTabed)];
    
    self.lblTag = [self createSubViewLabelWithFontSize:14 textColor:colorWithHexString(@"#ffffff")];
    [self.lblTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblTag.superview.mas_left).offset(12);
        make.centerY.equalTo(self.lblTag.superview.mas_centerY);
    }];
    
    self.imgTag = [self createSubViewImageViewWithImageNamed:@"Short_Article_Tag_Add"];
    [self.imgTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6, 6));
        make.left.equalTo(self.lblTag.mas_right).offset(12);
        make.right.equalTo(self.imgTag.superview.mas_right).offset(-12);
        make.centerY.equalTo(self.imgTag.superview.mas_centerY);
    }];
    
    [self.layer setCornerRadius:11.5];

    
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.contentView.superview);
//    }];
    
}

- (void)setTagText:(NSString *)text {
    self.lblTag.text = [self formattedText:text];
    if(self.lblTag.textSizeForSingleLine.width > MZL_TAGS_LABEL_WIDTH){ //如果标签换行后还是显示不下，需要设定一个最大宽度
       [self.lblTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(MZL_TAGS_LABEL_WIDTH);
       }];
    }
    [self layoutIfNeeded];  //need to update constraint
}

- (void)modifyState {
    if (_selected) {
        self.backgroundColor = colorWithHexString(@"#3d424c");
        self.imgTag.image = [UIImage imageNamed:@"Short_Article_Tag_Selected"];
    } else {
        self.backgroundColor = colorWithHexString(@"#b0b0b0");
        self.imgTag.image = [UIImage imageNamed:@"Short_Article_Tag_Add"];
    }
}

- (void)onItemTabed {
    _selected = !_selected;
    [self modifyState];
}

- (NSString *)formattedText:(NSString *)text {
    if (text.length == 2) {
        NSString *firstChar = [text substringToIndex:1];
        NSString *secondChar = [text substringWithRange:NSMakeRange(1, 1)];
        return [NSString stringWithFormat:@"%@  %@", firstChar, secondChar];
    }
    return text;
}
@end
