//
//  MZLFilterSectionView.h
//  Test
//
//  Created by Whitman on 14-9-5.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLFilterView.h"
#import "MZLModelFilterType.h"

#define WIDTH_MZL_FILTER_SECTION_VIEW 260.0
#define MZL_FILTER_SECTION_VIEW_H_MARGIN 15.0
#define NOTI_FILTER_MODIFIED @"NOTI_FILTER_MODIFIED"

@interface MZLFilterSectionView : MZLFilterView {
    @protected
    WeView *_bottom;
}

@property (nonatomic, strong) MZLModelFilterType *filterOptions;

- (MZLModelFilterType *)selectedFilterOptions;
- (void)setSelectedFilterOptions:(MZLModelFilterType *)selectedFilterOptions;
- (void)resetFilterOptions;
- (instancetype)initWithFilterOptions:(MZLModelFilterType *)filterOptions;

// protected for override
- (void)initBottomView;

@end
