//
//  COKeyboardToolbar.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-4.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "COKeyboardToolbar.h"
#import "COUtils.h"

@interface COKeyboardToolbar () {
    __weak UIView *_topBorder;
    __weak UIView *_bottomBorder;
}

@end

@implementation COKeyboardToolbar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)instance {
    return [self instanceWithHeight:CO_KB_TOOLBAR_HEIGHT];
}

+ (instancetype)instanceWithHeight:(CGFloat)height {
    COKeyboardToolbar *toolbar = [[COKeyboardToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
    [toolbar initInternal];
    
    return toolbar;
}

- (void)initInternal {
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *topBorder = [[UIView alloc] init];
    UIView *bottomBorder = [[UIView alloc] init];

    _topBorder = topBorder;
    _bottomBorder = bottomBorder;
    
    self.topBorder.backgroundColor = colorWithHexString(@"#e5e5e5"); // [UIColor colorWithWhite:0.678 alpha:1.0];
    self.bottomBorder.backgroundColor = colorWithHexString(@"#e5e5e5"); // [UIColor colorWithWhite:0.678 alpha:1.0];
    
    [self adjustBorderLayout];
    
    [self addSubview:topBorder];
    [self addSubview:bottomBorder];
}

- (void)adjustBorderLayout {
    self.topBorder.frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width, 0.5f);
    self.bottomBorder.frame = CGRectMake(0.0f, self.bounds.size.height - 1, self.bounds.size.width, 0.5f);
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self adjustBorderLayout];
//}

- (UIView *)topBorder {
    return _topBorder;
}

- (UIView *)bottomBorder {
    return _bottomBorder;
}

@end
