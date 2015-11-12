//
//  MZLFilterScrollView.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-10.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFilterView.h"

@protocol MZLFilterScrollViewDelegate <NSObject>

- (void)onFilterOptionsModified;

@optional
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


@interface MZLFilterScrollView : MZLFilterView

@property (nonatomic, strong) NSArray *filterOptions;
@property (nonatomic, weak) id<MZLFilterScrollViewDelegate> delegate;

/** 检测是否刷新界面 */
- (BOOL)isFilterModifiedSince:(NSDate *)dateToCompare;

- (NSArray *)selectedFilterOptions;
- (BOOL)isFilterOptionsVisible;

- (void)showWithDelegate:(id<MZLFilterScrollViewDelegate>)delegate;
- (void)hide;
- (void)showFilterOptions;
- (void)hideFilterOptions;

//+ (instancetype)instance;
//+ (instancetype)instance:(BOOL)createIfNil;
+ (instancetype)instanceWithFilterOptions:(NSArray *)filterOptions;

@end
