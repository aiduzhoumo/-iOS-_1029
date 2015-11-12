//
//  MZLShortArticleProgressView.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-2-3.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLShortArticleProgressView.h"
#import "UIView+MZLAdditions.h"
#import "FXBlurView.h"

#define ANIMATION_DURATION 0.8

@interface MZLShortArticleProgressView () {
    __weak FXBlurView *_blur;
    __weak UIView *_content;
    __weak UILabel *_lbl;
    __weak UIActivityIndicatorView *_indicator;
    __weak UIImageView *_cancelImage;
    BOOL _cancellable;
}

@property (nonatomic, weak) id<MZLShortArticleProgressViewDelegate> delegate;

@end

@implementation MZLShortArticleProgressView

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

+ (instancetype)instance {
    MZLShortArticleProgressView *instance = [[MZLShortArticleProgressView alloc] initWithFrame:globalWindow().bounds];
    return instance;
}

- (void)show {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.alpha = 0;
    [self addBlurBackground];
    [_indicator startAnimating];
    [globalWindow() addSubview:self];
    CGFloat duration = ANIMATION_DURATION;
    CGFloat delay = 2.0;
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self hide];
        });
    }];
}

- (void)showWithDelegate:(id<MZLShortArticleProgressViewDelegate>)delegate {
    self.delegate = delegate;
    [self show];
}

- (void)addBlurBackground {
    if (! self.viewToBlur) {
        return;
    }
    FXBlurView *blurView = [[FXBlurView alloc] init];
    _blur = blurView;
    blurView.tintColor = [UIColor lightGrayColor];
    blurView.blurRadius = 9.5;
    blurView.dynamic = YES;
    blurView.underlyingView = self.viewToBlur;
//    [_content insertSubview:blurView atIndex:0];
    [self insertSubview:blurView atIndex:0];
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(blurView.superview);
    }];
}

- (void)hide {
    [self hide:YES];
}

- (void)hide:(BOOL)animatedFlag {
    if (animatedFlag) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self onDidHide];
        }];
    } else {
        self.alpha = 0;
        [self onDidHide];
    }
}

- (void)onDidHide {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.viewToBlur = nil;
    [_blur removeFromSuperview];
    [self removeFromSuperview];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(onProgressViewHide)]) {
            [self.delegate onProgressViewHide];
        }
    }
}

- (void)setCancellable:(BOOL)flag {
    _cancellable = flag;
    _cancelImage.hidden = ! flag;
}

- (void)initInternal {
    UIView *content = [self createSubView];
    _content = content;
    content.layer.cornerRadius = 6.0;
    content.layer.masksToBounds = YES;
    UIView *contentBg = [content createSubView];
    contentBg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [contentBg co_withinParent];
    CGFloat vMargin = 20;
    CGFloat hMargin = 20;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicator = indicator;
    [content addSubview:indicator];
    [indicator co_insetsParent:UIEdgeInsetsMake(vMargin, COInvalidCons, COInvalidCons, COInvalidCons)];
    [indicator co_centerXParent];
    UILabel *lbl = [content createSubViewLabelWithFontSize:14 textColor:[UIColor whiteColor]];
    lbl.textAlignment = NSTextAlignmentCenter;
    _lbl = lbl;
//    lbl.numberOfLines = 0;
//    CGFloat lblPreferredWidth = 150;
//    lbl.preferredMaxLayoutWidth = lblPreferredWidth;
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(indicator.mas_bottom).offset(10);
        make.bottom.mas_equalTo(lbl.superview).offset(-vMargin);
        make.left.mas_equalTo(lbl.superview).offset(hMargin);
        make.right.mas_equalTo(lbl.superview).offset(-hMargin);
//        make.width.mas_equalTo(lblPreferredWidth);
    }];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(content.superview);
    }];
    UIImageView *image = [self createSubViewImageViewWithImageNamed:@"Short_Article_Cancel"];
    _cancelImage = image;
    [image co_width:24 height:24];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(content.mas_right);
        make.centerY.mas_equalTo(content.mas_top);
    }];
    [image addTapGestureRecognizer:self action:@selector(hide)];
    [content addTapGestureRecognizer:self action:@selector(dummyHandler)];
    [self addTapGestureRecognizer:self action:@selector(onClicked)];
}

#pragma mark - events handler

- (void)onClicked {
    if (_cancellable) {
        [self hide];
    }
}

- (void)dummyHandler {
    // do nothing
}

#pragma mark - property accessors

- (void)setDisplayText:(NSString *)displayText {
    _lbl.text = displayText;
}

- (NSString *)displayText {
    return _lbl.text;
}


@end
