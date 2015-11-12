//
//  MZLFilterView.h
//  Test
//
//  Created by Whitman on 14-9-5.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeView.h"

@interface MZLFilterView : WeView


#pragma mark - protected 
- (void)initInternal;


/** helper methods */
- (UIView *)createViewWithParentView:(UIView *)parent;
- (UIImageView *)createImageViewWithParentView:(UIView *)parent;
- (UILabel *)createLabelWithParentView:(UIView *)parent;
- (UIButton *)createButtonWithParentView:(UIView *)parent;
- (UIScrollView *)createScrollWithParentView:(UIView *)parent;

- (id)createView:(Class)viewClass parent:(UIView *)parent;


@end
