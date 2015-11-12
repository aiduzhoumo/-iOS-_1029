//
//  UIView+MZLAdditions.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIView+MZLAdditions.h"
#import "UIView+MBProgressHUDAdditions.h"
#import <Masonry/Masonry.h>
#import "UIImage+COAdditions.h"

@implementation UIView (MZLAdditions)

+ (UIImageView *)mzl_hairlineImageInView:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self mzl_hairlineImageInView:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (UIView *)createSubView {
    return [self createSubview:[UIView class]];
}

- (UILabel *)createSubViewLabel {
    return [self createSubview:[UILabel class]];
}

- (UILabel *)createSubViewLabelWithFontSize:(CGFloat)fontSize textColor:(UIColor *)textColor {
    return [self createSubViewLabelWithFont:MZL_FONT(fontSize) textColor:textColor];
}

- (UILabel *)createSubViewLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *lbl = [self createSubViewLabel];
    lbl.font = font;
    lbl.textColor = textColor;
    return lbl;
}

- (UIImageView *)createSubViewImageView {
    return [self createSubview:[UIImageView class]];
}

- (UIImageView *)createSubViewImageViewWithImageNamed:(NSString *)imageName {
    UIImageView *image = [self createSubViewImageView];
    image.image = [UIImage imageNamed:imageName];
    return image;
}

- (UITableView *)createSubViewTableView {
    return [self createSubview:[UITableView class]];
}

- (UITextField *)createSubTextFieldWithFontSize:(CGFloat)fontSize placeholder:(NSString *)placeholderText textColor:(UIColor *)textColor {
    UITextField *textField = [self createSubview:[UITextField class]];
    textField.font = MZL_FONT(fontSize);
    if (placeholderText) {
        textField.placeholder = placeholderText;
    }
    if (textColor) {
        textField.textColor = textColor;
    }
    return textField;
}

- (UIButton *)createSubViewBtn {
    UIButton *btn = [[UIButton alloc] init];
    [self addSubview:btn];
    return btn;
}

- (UIButton *)createSubBtnWithImageNamed:(NSString *)imageName imageSize:(CGSize)imageSize {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btn];
    UIImage *image= [UIImage imageNamed:imageName];
    if (imageSize.width > 0 && imageSize.height > 0) {
        image = [image scaledToSize:imageSize];
    }
    [btn setImage:image forState:UIControlStateNormal];
    return btn;
}

- (UIView *)createSepView {
    return [self createSepViewWithColor:@"#e5e5e5".co_toHexColor];
}

- (UIView *)createTopSepView {
    UIView *sep = [self createSepView];
    [sep co_topParent];
    return sep;
}

- (UIView *)createBottomSepView {
    UIView *sep = [self createSepView];
    [sep co_bottomParent];
    return sep;
}

- (UIView *)createSepViewWithColor:(UIColor *)color {
    UIView *sep = [self createSubView];
    sep.backgroundColor = color;
    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(sep.superview);
        make.height.mas_equalTo(0.5);
    }];
    return sep;
}

- (UIView *)mzl_createTabSeparator {
    return [self createSepViewWithColor:MZL_TAB_SEPARATOR_COLOR()];
}

#pragma mark - masonry convenient

- (CO_MAS_VIEW_INSETS_BLOCK)co_insetsParentBk {
    __weak typeof(self)weakSelf = self;
    CO_MAS_VIEW_INSETS_BLOCK block = ^ (CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
        [weakSelf co_insetsParent:UIEdgeInsetsMake(top, left, bottom, right)];
        return weakSelf;
    };
    return block;
}

- (CO_MAS_VIEW_INSETS_SIZE_BLOCK)co_insetsParentSizeBk {
    __weak typeof(self)weakSelf = self;
    CO_MAS_VIEW_INSETS_SIZE_BLOCK block = ^ (CGFloat top, CGFloat left, CGFloat bottom, CGFloat right, CGFloat width, CGFloat height) {
        [weakSelf co_insetsParent:UIEdgeInsetsMake(top, left, bottom, right) width:width height:height];
        return weakSelf;
    };
    return block;
}

- (UIView *)co_withinParent {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.superview);
    }];
    return self;
}

- (UIView *)co_offsetParent:(CGFloat)offset {
    UIEdgeInsets insets = UIEdgeInsetsMake(offset, offset, offset, offset);
    return [self co_insetsParent:insets];
}

- (UIView *)co_hOffsetParent:(CGFloat)offset {
    return [self co_insetsParent:UIEdgeInsetsMake(COInvalidCons, offset, COInvalidCons, offset)];
}

- (UIView *)co_vOffsetParent:(CGFloat)offset {
    return [self co_insetsParent:UIEdgeInsetsMake(offset, COInvalidCons, offset, COInvalidCons)];
}

- (UIView *)co_insetsParent:(UIEdgeInsets)insets {
    return [self co_insetsParent:insets width:COInvalidCons height:COInvalidCons];
}

- (UIView *)co_bottomParent {
    return [self co_insetsParent:UIEdgeInsetsMake(COInvalidCons, COInvalidCons, 0, COInvalidCons)];
}

- (UIView *)co_bottomParent:(CGFloat)offset {
    return [self co_insetsParent:UIEdgeInsetsMake(COInvalidCons, COInvalidCons, offset, COInvalidCons)];
}

- (UIView *)co_topParent {
    return [self co_insetsParent:UIEdgeInsetsMake(0, COInvalidCons, COInvalidCons, COInvalidCons)];
}

- (UIView *)co_topParentWithOffset:(CGFloat)offset {
    return [self co_insetsParent:UIEdgeInsetsMake(offset, COInvalidCons, COInvalidCons, COInvalidCons)];
}

- (UIView *)co_rightParent {
    return [self co_rightParentWithOffset:0];
}

- (UIView *)co_rightParentWithOffset:(CGFloat)offset {
    return [self co_insetsParent:UIEdgeInsetsMake(COInvalidCons, COInvalidCons, COInvalidCons, offset)];
}

- (UIView *)co_leftParentWithOffset:(CGFloat)offset {
    return [self co_insetsParent:UIEdgeInsetsMake(COInvalidCons, offset, COInvalidCons, COInvalidCons)];
}

- (UIView *)co_leftParent {
    return [self co_leftParentWithOffset:0];
}

/** using NSIntegerMax for invalid constraints */
- (UIView *)co_insetsParent:(UIEdgeInsets)insets width:(CGFloat)width height:(CGFloat)height {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        if (insets.top != COInvalidCons) {
            make.top.mas_equalTo(self.superview).offset(insets.top);
        }
        if (insets.bottom != COInvalidCons) {
            make.bottom.mas_equalTo(self.superview).offset(-insets.bottom);
        }
        if (insets.left != COInvalidCons) {
            make.left.mas_equalTo(self.superview).offset(insets.left);
        }
        if (insets.right != COInvalidCons) {
            make.right.mas_equalTo(self.superview).offset(-insets.right);
        }
        if (width != COInvalidCons) {
            make.width.mas_equalTo(width);
        }
        if (height != COInvalidCons) {
            make.height.mas_equalTo(height);
        }
    }];
    return self;
}

- (UIView *)co_centerParent {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.superview);
    }];
    return self;
}

- (UIView *)co_centerXParent {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.superview);
    }];
    return self;
}

- (UIView *)co_centerYParent {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.superview);
    }];
    return self;
}

- (UIView *)co_centerParentWithWidth:(CGFloat)width height:(CGFloat)height {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.superview);
        if (width != COInvalidCons) {
            make.width.mas_equalTo(width);
        }
        if (height != COInvalidCons) {
            make.height.mas_equalTo(height);
        }
    }];
    return self;
}

- (UIView *)co_leftCenterYParentWithWidth:(CGFloat)width height:(CGFloat)height {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.superview);
        make.centerY.mas_equalTo(self.superview);
        if (width != COInvalidCons) {
            make.width.mas_equalTo(width);
        }
        if (height != COInvalidCons) {
            make.height.mas_equalTo(height);
        }
    }];
    return self;
}

- (UIView *)co_rightCenterYParentWithWidth:(CGFloat)width height:(CGFloat)height {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.superview);
        make.centerY.mas_equalTo(self.superview);
        if (width != COInvalidCons) {
            make.width.mas_equalTo(width);
        }
        if (height != COInvalidCons) {
            make.height.mas_equalTo(height);
        }
    }];
    return self;
}


- (UIView *)co_leftFromView:(UIView *)anotherView offset:(CGFloat)offset {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(anotherView.mas_left).offset(offset);
    }];
    return self;
}

- (UIView *)co_leftFromRightOfView:(UIView *)anotherView offset:(CGFloat)offset {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(anotherView.mas_right).offset(offset);
    }];
    return self;
}

- (UIView *)co_rightFromLeftOfView:(UIView *)anotherView offset:(CGFloat)offset {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(anotherView.mas_left).offset(-offset);
    }];
    return self;
}

- (UIView *)co_topFromBottomOfView:(UIView *)anotherView offset:(CGFloat)offset {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(anotherView.mas_bottom).offset(offset);
    }];
    return self;
}

- (UIView *)co_bottomFromTopOfView:(UIView *)anotherView offset:(CGFloat)offset {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(anotherView.mas_top).offset(-offset);
    }];
    return self;
}

- (UIView *)co_leftFromRightOfPreSiblingWithOffset:(CGFloat)offset {
    UIView *anotherView = [self co_preSiblingView];
    [self co_leftFromRightOfView:anotherView offset:offset];
    return self;
}

- (UIView *)co_topFromBottomOfPreSiblingWithOffset:(CGFloat)offset {
    UIView *preSibling = [self co_preSiblingView];
    if (preSibling) {
        [self co_topFromBottomOfView:preSibling offset:offset];
    }
    return self;
}

- (UIView *)co_width:(CGFloat)width height:(CGFloat)height {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        if (width != COInvalidCons) {
            make.width.mas_equalTo(width);
        }
        if (height != COInvalidCons) {
            make.height.mas_equalTo(height);
        }
    }];
    return self;
}

- (UIView *)co_width:(CGFloat)width {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    return self;
}

- (UIView *)co_updateWidth:(CGFloat)width {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    return self;
}

- (UIView *)co_height:(CGFloat)height {
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    return self;
}

- (UIView *)co_heightZeroIfNoSubviews {
    if (self.subviews.count == 0) {
        [self co_height:0];
    }
    return self;
}

- (UIView *)co_updateHeight:(CGFloat)height {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    return self;
}

- (UIView *)co_encloseSubviews {
    if (self.subviews.count > 0) {
        UIView *lastSubview = [self.subviews lastObject];
        [lastSubview co_bottomParent];
    }
    return self;
}

@end
