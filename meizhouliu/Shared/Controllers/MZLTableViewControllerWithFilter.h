//
//  MZLTableViewControllerWithFilter.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-17.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLTableViewController.h"
#import "MZLFilterScrollView.h"
#import "MZLFilterContentView.h"

@class MZLFilterParam;

@interface MZLTableViewControllerWithFilter : MZLTableViewController<MZLFilterViewDelegate> {
    @protected
    MZLFilterContentView * _filterView;
    BOOL _requireRefreshOnViewWillAppear;
}


// protected
- (BOOL)_shouldShowFilterView;
- (NSArray *)_filterOptions;
- (void)filterHasModified;
- (BOOL)_shouldRefreshOnViewWillAppear;
/** return an array of strings to display on no record view */
//- (NSArray *)_textsOnFilterNoRecord;
//- (UIView *)_superViewForNoRecordView;
- (NSArray *)noRecordTextsWithFilters;
- (NSArray *)noRecordTextsWithoutFilters;

// protected for load and load more
- (void)_loadModelsWithoutFilters;
- (void)_loadModelsWithFilters:(MZLFilterParam *)filter;
- (void)_loadMoreWithFilters:(MZLFilterParam *)filter;
- (void)_loadMoreWithoutFilters:(MZLPagingSvcParam *)pagingParam;

// public
- (MZLFilterParam *)filterParamWithSelectedCity;
- (MZLFilterParam *)filterParamWithDestination:(NSString *)destination;
//- (void)toggleStatusForFilters:(BOOL)isShown;

@end
