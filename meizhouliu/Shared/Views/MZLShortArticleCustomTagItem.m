//
//  MZLShortArticleCustomTagItem.m
//  mzl_mobile_ios
//
//  Created by race on 15/1/15.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLShortArticleCustomTagItem.h"
#import "UIView+MZLAdditions.h"
#import "UILabel+COAdditions.h"

#define MZL_CUSTOM_TAGS_VIEW_WIDTH CO_SCREEN_WIDTH - 46

@interface MZLShortArticleCustomTagItem ()

//@property (nonatomic,weak) UILabel *lblTag;
@property(nonatomic,assign) BOOL    selected;

@end



@implementation MZLShortArticleCustomTagItem

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
    [self setBackgroundColor:colorWithHexString(@"#3d424c")];
    [self addTapGestureRecognizer:self action:@selector(onItemTabed)];
    
    self.lblTag = [self createSubViewLabelWithFontSize:14 textColor:colorWithHexString(@"#ffffff")];
    [self.lblTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lblTag.superview.mas_left).offset(12);
        make.right.equalTo(self.lblTag.superview.mas_right).offset(-12);
        make.centerY.equalTo(self.lblTag.superview.mas_centerY);
    }];
    
    [self.layer setCornerRadius:11.5];
    
}

- (void)setTagText:(NSString *)text {
    self.lblTag.text = [self formattedText:text];
    if(self.lblTag.textSizeForSingleLine.width > MZL_CUSTOM_TAGS_VIEW_WIDTH){ //如果标签换行后还是显示不下，需要设定一个最大宽度
        [self.lblTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(MZL_CUSTOM_TAGS_VIEW_WIDTH);
        }];
    }
    [self layoutIfNeeded];  //need to update constraint
}

- (void)onItemTabed {
   
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
