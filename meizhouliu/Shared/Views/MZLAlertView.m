//
//  MZLAlertView.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-4.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLAlertView.h"
#import "UIView+MZLAdditions.h"
#import "FXBlurView.h"

@interface MZLAlertView () {
    __weak UIImageView *_image;
    __weak UILabel *_lbl;
    __weak UIView *_content;
}

@end

@implementation MZLAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initInternal];
    }
    return self;
}

+ (void)showWithImageNamed:(NSString *)image text:(NSString *)text {
    [self showWithImage:[UIImage imageNamed:image] text:text viewForBlur:nil];
}

+ (void)showWithImage:(UIImage *)image text:(NSString *)text viewForBlur:(UIView *)viewForBlur {
    MZLAlertView *alert = [[MZLAlertView alloc] initWithFrame:globalWindow().bounds];
    [alert updateWithImage:image text:text];
    alert.alpha = 0;
    if (viewForBlur) {
        [alert addBlurBackground:viewForBlur];
    }
    [globalWindow() addSubview:alert];
    CGFloat duration = 0.8;
    CGFloat delay = 1.0;
    [UIView animateWithDuration:duration animations:^{
        alert.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:duration animations:^{
                alert.alpha = 0;
            } completion:^(BOOL finished) {
                [alert removeFromSuperview];
            }];
        });
    }];
}

- (void)updateWithImage:(UIImage *)image text:(NSString *)text {
    _image.image = image;
    _lbl.text = text;
}

- (void)addBlurBackground:(UIView *)viewToCapture {
    FXBlurView *blurView = [[FXBlurView alloc] init];
    blurView.blurRadius = 9.5;
    blurView.dynamic = YES;
    blurView.underlyingView = viewToCapture;
    [_content insertSubview:blurView atIndex:0];
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(blurView.superview);
    }];
}

- (void)initInternal {
    UIView *content = [self createSubView];
    _content = content;
    content.layer.cornerRadius = 6.0;
    content.layer.masksToBounds = YES;
    UIView *contentBg = [content createSubView];
    contentBg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [contentBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(contentBg.superview);
    }];
//    content.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    CGFloat vMargin = 20;
    CGFloat hMargin = 20;
    UIImageView *imageView = [content createSubViewImageView];
    _image = imageView;
    CGFloat imageWidth = 42.0;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView.superview);
        make.top.mas_equalTo(imageView.superview).offset(vMargin);
        make.size.mas_equalTo(CGSizeMake(imageWidth, imageWidth));
    }];
    UILabel *lbl = [content createSubViewLabelWithFontSize:14 textColor:[UIColor whiteColor]];
    lbl.textAlignment = NSTextAlignmentCenter;
    _lbl = lbl;
    lbl.numberOfLines = 0;
    CGFloat lblPreferredWidth = 150;
    lbl.preferredMaxLayoutWidth = lblPreferredWidth;
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).offset(10);
        make.bottom.mas_equalTo(lbl.superview).offset(-vMargin);
        make.left.mas_equalTo(lbl.superview).offset(hMargin);
        make.right.mas_equalTo(lbl.superview).offset(-hMargin);
        make.width.mas_equalTo(lblPreferredWidth);
    }];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(content.superview);
    }];
}


@end
