//
//  MZLFilterItemFeature.m
//  mzl_mobile_ios
//
//  Created by race on 14/11/18.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFilterItemWithImage.h"
#import <Masonry/Masonry.h>

@interface MZLFilterItemWithImage (){
    UIImageView *_placeHolderView;
    UIImageView *_img;
    UILabel *_lbl;
//    BOOL _isSelected;
    NSString *_imageName;
}

@end

@implementation MZLFilterItemWithImage

- (void)initUI {
    
    // 筛选项 大小
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@66);
        make.height.equalTo(@70);
    }];
    
    // 筛选项 文字描述
    _lbl = [self createLabelWithParentView:self];
    _lbl.font = MZL_FONT(14);
    _lbl.textColor = colorWithHexString(@"#7f7f7f");
    [_lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    // 筛选项 图片
    _img = [self createImageViewWithParentView:self];
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(@50);
        make.centerX.equalTo(self);
        make.bottom.equalTo(_lbl.mas_top).offset(-6);
    }];

    // 填充view
    _placeHolderView = [self createImageViewWithParentView:self];
    _placeHolderView.image = [UIImage imageNamed:@"Filter_Option_Bg"];
    _placeHolderView.alpha = 0;
    [_placeHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_img);
        make.width.equalTo(@0);
        make.height.equalTo(@0);
    }];
    [_placeHolderView toRoundShape];
}


#pragma mark - public

//- (BOOL)isSelected {
//    return _isSelected;
//}
//
//- (void)setSelected:(BOOL)flag {
//    _isSelected = flag;
//    [self modifyState];
//}

- (void)setText:(NSString *)text {
    _lbl.text = text;
}


- (void)setImage:(NSString *)imageName {
    _imageName = imageName;
    _img.image = [UIImage imageNamed:_imageName];
}

//- (void)toggleSelected {
//    _isSelected = ! _isSelected;
//    [self modifyState];
////    if (self.delegate) {
////        [self.delegate onFilterOptionStateModified];
////    }
//}

#pragma mark - helper methods

- (void)modifyState {
    if (_isSelected) {
        [self animateOnViewShow:_placeHolderView];
    } else {
        [self animateOnViewHide:_placeHolderView];
    }
}


- (void)animateOnViewShow:(UIView *)view {
    UIGestureRecognizer *gestureRecognizer;
    if (view.superview.gestureRecognizers.count > 0) {
        gestureRecognizer = view.superview.gestureRecognizers[0];
    }
    gestureRecognizer.enabled = NO;
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_img.size);
    }];
    
     _lbl.textColor = MZL_COLOR_YELLOW_FDD414();
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
         view.alpha = 1;
        [view layoutIfNeeded];
    } completion:^(BOOL finished) {
        _img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",_imageName,@"_Hi"]];
        
        [UIView animateWithDuration:0.1 animations:^{
            view.alpha = 0;
        } completion:^(BOOL finished) {
            gestureRecognizer.enabled = YES;
        }];
    }];
}

- (void)animateOnViewHide:(UIView *)view {
    UIGestureRecognizer *gestureRecognizer;
    if (view.superview.gestureRecognizers.count > 0) {
        gestureRecognizer = view.superview.gestureRecognizers[0];
    }
    gestureRecognizer.enabled = NO;
     _lbl.textColor = colorWithHexString(@"#7f7f7f");
    
    [UIView animateWithDuration:0.1 animations:^{
        view.alpha = 1;
    } completion:^(BOOL finished) {
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeZero);
        }];
         _img.image = [UIImage imageNamed:_imageName];
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
             view.alpha = 0.0;
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
           gestureRecognizer.enabled = YES;
        }];
    }];
}

@end
