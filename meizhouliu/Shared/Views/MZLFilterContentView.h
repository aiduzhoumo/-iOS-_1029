//
//  MZLFilterContentView.h
//  mzl_mobile_ios
//
//  Created by race on 14/11/17.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFilterView.h"


@protocol MZLFilterViewDelegate <NSObject>

- (void)onFilterOptionsModified;

@optional

- (void)hideFilterView;
- (void)showFilterView;

- (void)onFilterOptionsShown;
- (void)onFilterOptionsHidden;
- (void)onFilterOptionsWillShow;
- (void)onFilterOptionsWillHide;
/** 当没有选择目的地时，由此处判断是否需要弹出filterOptions */
- (BOOL)onLocationNotDetermined;

// for showing fitler options
- (void)addSwipeGestureRecognizerToShowFilterOptions:(UISwipeGestureRecognizer *)swipeGesture;
- (void)removeSwipeGestureRecognizer:(UISwipeGestureRecognizer *)swipeGesture;

@end

@interface MZLFilterContentView : MZLFilterView {
    @protected
    __weak UIScrollView *_filterScroll;
    __weak UIView *_vwContent;
    __weak UIView *_vwFeature;
    NSMutableArray *_filterSectionViews;
}

@property (nonatomic, strong) NSArray *filterOptions;
@property (nonatomic, weak) id<MZLFilterViewDelegate> delegate;

/** 检测是否刷新界面 */
- (BOOL)isFilterModifiedSince:(NSDate *)dateToCompare;

- (NSArray *)selectedFilterOptions;
- (BOOL)isFilterOptionsVisible;

- (void)showWithDelegate:(id<MZLFilterViewDelegate>)delegate;
- (void)hide;
- (void)showFilterOptions;
- (void)hideFilterOptions;

- (BOOL)hasFilters;

/** protected */
- (void)initFilterScroll;
- (BOOL)hasFilterBar;
- (void)initFilterSections;

- (CGFloat)filterOptionsViewOriginX;
- (CGFloat)filterContentOriginX;

- (NSString *)_filterTitle;
- (void)initFilterTitle:(NSString *)title;
- (void)initCloseButton;
- (void)initBottomButtons;

- (void)onFilterModified;
- (void)onInternalFilterModified;

- (void)show:(BOOL)showFlag;

- (void)createFilterOptionsViewWithFilterOptions:(NSArray *)filterOptions showDistanceFlag:(BOOL)flag;
- (UIButton *)createButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor borderColor:(UIColor *)borderColor action:(SEL)action;

+ (instancetype)instanceWithFilterOptions:(NSArray *)filterOptions showDistanceFlag:(BOOL)flag;

@end
