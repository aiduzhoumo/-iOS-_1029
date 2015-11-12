//
//  MZLFilterSectionView.m
//  Test
//
//  Created by Whitman on 14-9-5.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFilterSectionView.h"

@interface MZLFilterSectionView () {
    UIImageView *_topLeftImageView;
    UILabel *_topRightLbl;
    WeView *_top;
}

@end

@implementation MZLFilterSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (instancetype)initWithFilterOptions:(MZLModelFilterType *)filterOptions {
    self = [super init];
    if (self) {
        self.filterOptions = filterOptions;
        [self initInternalWithFilterOptions];
    }
    return self;
}

#pragma mark - init

- (void)initInternal {
    _top = [[WeView alloc] init];
    _bottom = [[WeView alloc] init];
    
    [[[self addSubviewsWithVerticalLayout:@[_top, _bottom]]
      setVSpacing:16.0]
     setHAlign:H_ALIGN_LEFT];
    
}

- (void)initInternalWithFilterOptions {
    [self initTopView];
    [self initBottomView];
}

#pragma mark - public

- (MZLModelFilterType *)selectedFilterOptions {
    return nil;
}

- (void)setSelectedFilterOptions:(MZLModelFilterType *)selectedFilterOptions {
}

- (void)resetFilterOptions {
}

#pragma mark - protected for override

- (void)initTopView {
    _topLeftImageView = [[UIImageView alloc] init];
    _topLeftImageView.image = [self.filterOptions filterTypeIcon];
    [_topLeftImageView setFixedDesiredSize:CGSizeMake(16.0, 16.0)];
    _topRightLbl = [[UILabel alloc] init];
    _topRightLbl.text = self.filterOptions.displayName;
    _topRightLbl.textColor = MZL_COLOR_GREEN_85DDCC();
    _topRightLbl.font = MZL_FONT(16.0);
    [[[[[_top addSubviewsWithHorizontalLayout:@[_topLeftImageView, _topRightLbl]]
       setHSpacing:3]
      setHAlign:H_ALIGN_LEFT]
     setVAlign:V_ALIGN_TOP] setLeftMargin:MZL_FILTER_SECTION_VIEW_H_MARGIN];
}

- (void)initBottomView {
}



@end
