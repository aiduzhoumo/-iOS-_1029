//
//  UIView+MZLAdditions.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

typedef UIView *(^CO_MAS_VIEW_INSETS_BLOCK)(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);
typedef UIView *(^CO_MAS_VIEW_INSETS_SIZE_BLOCK)(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right, CGFloat width, CGFloat height);

#define COInvalidCons NSIntegerMax

@interface UIView (MZLAdditions)

+ (UIImageView *)mzl_hairlineImageInView:(UIView *)view;

- (UIView *)createSubView;

- (UILabel *)createSubViewLabel;
- (UILabel *)createSubViewLabelWithFontSize:(CGFloat)fontSize textColor:(UIColor *)textColor;
- (UILabel *)createSubViewLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor;

- (UIImageView *)createSubViewImageView;
- (UIImageView *)createSubViewImageViewWithImageNamed:(NSString *)imageName;

- (UITableView *)createSubViewTableView;

- (UITextField *)createSubTextFieldWithFontSize:(CGFloat)fontSize placeholder:(NSString *)placeholderText textColor:(UIColor *)textColor;

- (UIButton *)createSubViewBtn;
- (UIButton *)createSubBtnWithImageNamed:(NSString *)imageName imageSize:(CGSize)imageSize;

- (UIView *)createSepView;
- (UIView *)createSepViewWithColor:(UIColor *)color;
- (UIView *)createTopSepView;
- (UIView *)createBottomSepView;
- (UIView *)mzl_createTabSeparator;

#pragma mark - masonry convenient

@property (nonatomic, readonly) CO_MAS_VIEW_INSETS_BLOCK co_insetsParentBk;
@property (nonatomic, readonly) CO_MAS_VIEW_INSETS_SIZE_BLOCK co_insetsParentSizeBk;

- (UIView *)co_withinParent;
- (UIView *)co_offsetParent:(CGFloat)offset;
- (UIView *)co_hOffsetParent:(CGFloat)offset;
- (UIView *)co_vOffsetParent:(CGFloat)offset;
- (UIView *)co_insetsParent:(UIEdgeInsets)insets;
/** using NSIntegerMax for invalid constraints */
- (UIView *)co_insetsParent:(UIEdgeInsets)insets width:(CGFloat)width height:(CGFloat)height;
- (UIView *)co_topParent;
- (UIView *)co_topParentWithOffset:(CGFloat)offset;
- (UIView *)co_bottomParent:(CGFloat)offset;
- (UIView *)co_bottomParent;
- (UIView *)co_rightParentWithOffset:(CGFloat)offset;
- (UIView *)co_rightParent;
- (UIView *)co_leftParentWithOffset:(CGFloat)offset;
- (UIView *)co_leftParent;

- (UIView *)co_centerParent;
- (UIView *)co_centerXParent;
- (UIView *)co_centerYParent;

- (UIView *)co_leftCenterYParentWithWidth:(CGFloat)width height:(CGFloat)height;
- (UIView *)co_rightCenterYParentWithWidth:(CGFloat)width height:(CGFloat)height;
//- (UIView *)co_centerParentWithWidth:(CGFloat)width height:(CGFloat)height;

- (UIView *)co_leftFromRightOfView:(UIView *)anotherView offset:(CGFloat)offset;
- (UIView *)co_rightFromLeftOfView:(UIView *)anotherView offset:(CGFloat)offset;
- (UIView *)co_topFromBottomOfView:(UIView *)anotherView offset:(CGFloat)offset;
- (UIView *)co_bottomFromTopOfView:(UIView *)anotherView offset:(CGFloat)offset;
- (UIView *)co_leftFromRightOfPreSiblingWithOffset:(CGFloat)offset;
- (UIView *)co_topFromBottomOfPreSiblingWithOffset:(CGFloat)offset;

- (UIView *)co_width:(CGFloat)width height:(CGFloat)height;
- (UIView *)co_width:(CGFloat)width;
- (UIView *)co_height:(CGFloat)height;
- (UIView *)co_heightZeroIfNoSubviews;
- (UIView *)co_updateHeight:(CGFloat)height;
- (UIView *)co_updateWidth:(CGFloat)width;

- (UIView *)co_encloseSubviews;

@end
