//
//  MZLFilterView.m
//  Test
//
//  Created by Whitman on 14-9-5.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFilterView.h"

@implementation MZLFilterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initInternal];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initInternal];
    }
    return self;
}

// Fix WeView的一个bug，一般UIView的子类不需要同时定义init和initWithFrame有一样的流程，因为init会默认调用initWithFrame:CGRectZero
- (id)init {
    return [self initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (void)initInternal {
}


#pragma mark - helper methods

- (UIView *)createViewWithParentView:(UIView *)parent {
    return [self createView:[UIView class] parent:parent];
}

- (UIImageView *)createImageViewWithParentView:(UIView *)parent {
    return [self createView:[UIImageView class] parent:parent];
}

- (UILabel *)createLabelWithParentView:(UIView *)parent {
    return [self createView:[UILabel class] parent:parent];
}

- (UIButton *)createButtonWithParentView:(UIView *)parent {
    return [self createView:[UIButton class] parent:parent];
}

- (UIScrollView *)createScrollWithParentView:(UIView *)parent {
    return [self createView:[UIScrollView class] parent:parent];
}

- (id)createView:(Class)viewClass parent:(UIView *)parent {
    id view = [[viewClass alloc] init];
    [parent addSubview:view];
    return view;
}

@end
