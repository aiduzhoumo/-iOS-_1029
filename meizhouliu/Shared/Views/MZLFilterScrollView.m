//
//  MZLFilterScrollView.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-10.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFilterScrollView.h"
#import "MZLFilterBar.h"
#import <POPSpringAnimation.h>
#import "MZLModelFilterType.h"
#import "MZLFilterSectionDistanceView.h"
#import "MZLFilterSectionOptionView.h"
#import <IBMessageCenter.h>
#import "UIView+COPopAdditions.h"
#import "UIView+MBProgressHUDAdditions.h"

//#define LEFT_MARGIN_FILTER_SCROLL_VIEW 30.0
#define WIDTH_MZL_FILTER_SCROLL_VIEW_SCROLL 260.0 
// (WIDTH_MZL_FILTER_SCROLL_VIEW - LEFT_MARGIN_FILTER_SCROLL_VIEW)
#define WIDTH_MZL_FILTER_SCROLL_VIEW (WIDTH_MZL_FILTER_SCROLL_VIEW_SCROLL + WIDTH_MZL_FILTER_BAR)
#define INITIAL_ORIGIN_X (CO_SCREEN_WIDTH - WIDTH_MZL_FILTER_BAR)
#define SHOW_FILTER_OPTIONS_ORIGIN_X (CO_SCREEN_WIDTH - WIDTH_MZL_FILTER_SCROLL_VIEW)
// (CO_SCREEN_WIDTH - WIDTH_MZL_FILTER_BAR)
#define WIDTH_LEFT_VIEW SHOW_FILTER_OPTIONS_ORIGIN_X
//#define LEFT_MARGIN_FILTER_BAR (CO_SCREEN_WIDTH - WIDTH_MZL_FILTER_SCROLL_VIEW)

@interface MZLFilterScrollView() {
    __weak UIImageView *_shadowView;
    UISwipeGestureRecognizer *_swipeGestureForDelegate;
    NSTimer *_timer;
    NSTimer *_transparentTimer;
//    __weak UIActivityIndicatorView *_indicator;
    __weak MZLFilterBar *_filterBar;
    // 放在整个scroll的左边，用以阻挡交互及扩大swipe手势的范围
    WeView *_leftView;
    NSArray *_savedSelectedFilterOptions;
    NSDate *_filterModifiedTimeStamp;
}

@property (nonatomic, weak) UIScrollView *contentScroll;
@property (nonatomic, weak) WeView *contentViewInScroll;
@property (nonatomic, strong) NSArray *filterSections;

@end

@implementation MZLFilterScrollView

- (void)dealloc {
    [IBMessageCenter removeMessageListenersForTarget:self];
}

#pragma mark - override 

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    UIView *hitTestView = [super hitTest:point withEvent:event];
    // 没有显示filter options的时候，除了filterBar，禁掉其它区域的事件响应
    if (! [self isFilterOptionsVisible]) {
        if (hitTestView == _filterBar) {
            return hitTestView;
        }
        return nil;
    }
    return hitTestView;
}

#pragma mark - init

- (void)initInternal {
//    [self addGlobalMsgListener];
    [self createShowHideGestures];
    [self initInternalControls];
}

- (void)createShowHideGestures {
//    UISwipeGestureRecognizer *swipeToShowGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showFilterOptions)];
//    swipeToShowGesture.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self addGestureRecognizer:swipeToShowGesture];
    UISwipeGestureRecognizer *swipeToHideGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideFilterOptions)];
    swipeToHideGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeToHideGesture];
}

- (void)initInternalControls {
    WeView *leftView = [[WeView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_LEFT_VIEW, CO_SCREEN_HEIGHT)];
    UISwipeGestureRecognizer *swipeToHideGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideFilterOptions)];
    swipeToHideGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [leftView addGestureRecognizer:swipeToHideGesture];
    leftView.backgroundColor = [UIColor clearColor];
    _leftView = leftView;
    
    WeView *leftClearView = [[WeView alloc] init];
    [leftClearView setHStretches];
    [leftClearView setVStretches];
    leftClearView.backgroundColor = [UIColor clearColor];
    UIImageView *shadowView = [[UIImageView alloc] init];
    shadowView.image = [UIImage imageNamed:@"Filter_Shadow"];
    [shadowView setFixedDesiredWidth:20.0];
    _shadowView = shadowView;
    _shadowView.hidden = YES;
    UIScrollView *scroll = [[UIScrollView alloc] init];
    self.contentScroll = scroll;
    [scroll setVStretches];
    [scroll setFixedDesiredWidth:WIDTH_MZL_FILTER_SCROLL_VIEW_SCROLL];
    scroll.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.96];
    [self addSubviewsWithHorizontalLayout:@[leftClearView, shadowView, scroll]];
    MZLFilterBar *filterBar = [UIView viewFromNib:@"MZLFilterBar"];
    _filterBar = filterBar;
    [self makeFilterBarTransparent:YES animatedFlag:NO];
    //    [[[self addSubviewWithCustomLayout:filterBar] setHAlign:H_ALIGN_LEFT] setLeftMargin:LEFT_MARGIN_FILTER_BAR];
    [[self addSubviewWithCustomLayout:filterBar] setHAlign:H_ALIGN_LEFT];
    
    [filterBar addTapGestureRecognizer:self action:@selector(toggleTranslation)];
}

- (void)createFilterOptionView {
//    WeView *contentView = [[WeView alloc] init];
//    NSMutableArray *subviews = [NSMutableArray array];
//    NSMutableArray *filterSectionViews = [NSMutableArray array];
//    for (MZLModelFilterType *filterType in self.filterOptions) {
//        MZLFilterSectionView *section;
//        if (filterType.identifier == MZLFilterTypeDistance) {
//            section = [[MZLFilterSectionDistanceView alloc] initWithFilterOptions:filterType];
//        } else {
//            section = [[MZLFilterSectionOptionView alloc] initWithFilterOptions:filterType];
//        }
//        [subviews addObject:section];
//        [filterSectionViews addObject:section];
//        // register notification for filter changed
//        [IBMessageCenter addMessageListener:NOTI_FILTER_MODIFIED source:section target:self action:@selector(onFilterModified)];
//    }
//    self.filterSections = filterSectionViews;
//    [[[contentView addSubviewsWithVerticalLayout:subviews]
//      setVMargin:20.0]
//     setVSpacing:30.0];
//    CGSize contentSize = [contentView sizeThatFits:CGSizeMake(WIDTH_MZL_FILTER_SCROLL_VIEW_SCROLL, 0)];
//    contentView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
//    self.contentScroll.contentSize = contentSize;
//    UIButton *resetBtn = [[UIButton alloc] init];
//    [resetBtn setTitleColor:MZL_COLOR_GREEN_85DDCC() forState:UIControlStateNormal];
//    [resetBtn setTitle:@"清除条件" forState:UIControlStateNormal];
//    resetBtn.titleLabel.font = MZL_FONT(16.0);
//    [resetBtn addTarget:self action:@selector(resetFilterOptions) forControlEvents:UIControlEventTouchUpInside];
//    [[[[[contentView addSubviewWithCustomLayout:resetBtn]
//      setHAlign:H_ALIGN_RIGHT]
//     setRightMargin:15.0]
//     setVAlign:V_ALIGN_TOP]
//     setTopMargin:15.0];
//    
////    // toolbar 铺在底层营造毛玻璃效果
////    UIToolbar *bgToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, contentSize.width, contentSize.height)];
////    [bgToolBar setTintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.96]];
////    [self.contentScroll addSubview:bgToolBar];
//    self.contentViewInScroll = contentView;
//    [self.contentScroll addSubview:contentView];
}

- (void)createFilterOptionsViewWithFilterOptions:(NSArray *)filterOptions {
    self.filterOptions = filterOptions;
    if (self.contentViewInScroll) {
        [self.contentViewInScroll removeFromSuperview];
    }
    [self createFilterOptionView];
//    NSArray *mergedSelectedFilterOptions = [MZLModelFilterType mergeFilterTypes:_savedSelectedFilterOptions new:[MZLSharedData selectedFilterOptions]];
//    _savedSelectedFilterOptions = mergedSelectedFilterOptions;
    NSArray *selected = [MZLSharedData selectedFilterOptions];
    NSArray *intersected = [MZLModelFilterType intersectFilterTypesFromA:selected withB:filterOptions];
    intersected = [self removeUnnecesaryFilters:intersected];
//    [MZLSharedData setSelectedFilterOptions:intersectedSelectedFilterOptions];
    [self setSelectedFilterOptions:intersected];
    [_filterBar toggleFilterImage:intersected.count > 0];
}

- (void)toggleTranslation {
    if ([UIView isProgressIndicatorVisible]) { // 当前有活跃的service
        return;
    }
    [self showFilterOptions:! [self isFilterOptionsVisible]];
}

#pragma mark - filter bar show/transparent

- (void)makeFilterBarTransparent:(BOOL)transparentFlag animatedFlag:(BOOL)animatedFlag {
    CGFloat alphaToValue = transparentFlag ? 0.7 : 1.0;
    if (animatedFlag) {
        [UIView animateWithDuration:0.5 animations:^{
            _filterBar.alpha = alphaToValue;
        }];
    } else {
        _filterBar.alpha = alphaToValue;
    }
}

- (void)makeFilterBarTransparent {
    [self makeFilterBarTransparent:YES animatedFlag:YES];
}

#pragma mark - show/hide filter options

- (void)showFilterOptions:(BOOL)showFlag {
    BOOL currentFilterOptionsShowFlag = [self isFilterOptionsVisible];
    if (currentFilterOptionsShowFlag == showFlag) {
        return;
    }
    // 显示前检查是否有location
    if (! [MZLSharedData selectedCity]) {
        if ([self.delegate respondsToSelector:@selector(onLocationNotDetermined)]) {
            if (! [self.delegate onLocationNotDetermined]) {
                return;
            }
        }
    }
    if (showFlag) {
        [_transparentTimer invalidate];
        [globalWindow() addSubview:_leftView];
        [self makeFilterBarTransparent:NO animatedFlag:NO];
        if ([self.delegate respondsToSelector:@selector(onFilterOptionsWillShow)]) {
            [self.delegate onFilterOptionsWillShow];
        }
    } else {
        [_leftView removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(onFilterOptionsWillHide)]) {
            [self.delegate onFilterOptionsWillHide];
        }
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:showFlag withAnimation:UIStatusBarAnimationFade];
    _shadowView.hidden = ! showFlag;
    CGFloat toX = showFlag ? SHOW_FILTER_OPTIONS_ORIGIN_X : INITIAL_ORIGIN_X; // LEFT_MARGIN_FILTER_SCROLL_VIEW : INITIAL_ORIGIN_X;
    POPSpringAnimation *anim = [self co_animateFrameX:toX];
    anim.delegate = self;
}

- (void)showFilterOptions {
    [self showFilterOptions:YES];
}

- (void)hideFilterOptions {
    [self showFilterOptions:NO];
}

- (void)onFilterOptionsShownOrHidden {
    if (self.delegate) {
        if ([self isFilterOptionsVisible]) {
            if ([self.delegate respondsToSelector:@selector(onFilterOptionsShown)]) {
                [self.delegate onFilterOptionsShown];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(onFilterOptionsHidden)]) {
                [self.delegate onFilterOptionsHidden];
            }
            _transparentTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(makeFilterBarTransparent) userInfo:nil repeats:NO];
        }
    }
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    [self onFilterOptionsShownOrHidden];
}

#pragma mark - filter modified notification

- (void)onFilterModified {
    NSArray *selectedFilters = [self selectedFilterOptions];
    selectedFilters = [self removeUnnecesaryFilters:selectedFilters];
    NSMutableArray *savedFilters = [NSMutableArray arrayWithArray:[MZLSharedData selectedFilterOptions]];
    for (MZLModelFilterType *filter in self.filterOptions) {
        // 先找selected是否有匹配
        MZLModelFilterType *matchedSelected;
        for (MZLModelFilterType *temp in selectedFilters) {
            if (temp.identifier == filter.identifier) {
                matchedSelected = temp;
                break;
            }
        }
        // 再找saved是否有匹配
        NSInteger matchedSavedIndex = -1;
        for (int i = 0; i < savedFilters.count; i ++) {
            MZLModelFilterType *temp = savedFilters[i];
            if (temp.identifier == filter.identifier) {
                matchedSavedIndex = i;
                break;
            }
        }
        if (matchedSelected) {
            if (matchedSavedIndex == -1) {
                [savedFilters addObject:matchedSelected];
            } else {
                savedFilters[matchedSavedIndex] = matchedSelected;
            }
        } else {
            if (matchedSavedIndex > -1) {
                [savedFilters removeObjectAtIndex:matchedSavedIndex];
            }
        }
    }
    NSArray *transformedSelectedFilters = [NSArray arrayWithArray:savedFilters];
    transformedSelectedFilters = [self removeUnnecesaryFilters:transformedSelectedFilters];
    
    [MZLSharedData setSelectedFilterOptions:transformedSelectedFilters];
    [_filterBar toggleFilterImage:selectedFilters.count > 0];
    _filterModifiedTimeStamp = [NSDate date];
    [self startTimerIfNecessary];
}

- (BOOL)isFilterModifiedSince:(NSDate *)dateToCompare {
    if (! _filterModifiedTimeStamp) {
        return NO;
    }
    if (! dateToCompare || [_filterModifiedTimeStamp timeIntervalSinceDate:dateToCompare] > 0) {
        return YES;
    }
    return NO;
}

- (void)startTimerIfNecessary {
    if (_timer) {
        return;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sendFilterMessage) userInfo:nil repeats:NO];
}

- (void)sendFilterMessage {
    _timer = nil;
    [IBMessageCenter sendMessageNamed:MZL_NOTIFICATION_FILTER_MODIFIED forSource:self];
}

#pragma mark - public methods

- (BOOL)isFilterOptionsVisible {
    return self.x <= SHOW_FILTER_OPTIONS_ORIGIN_X;
}

- (NSArray *)selectedFilterOptions {
    NSMutableArray *result = [NSMutableArray array];
    for (MZLFilterSectionView *sectionView in self.filterSections) {
        MZLModelFilterType *filter = [sectionView selectedFilterOptions];
        if (filter) {
            [result addObject:filter];
        }
    }
    return result;
}

static MZLFilterScrollView *_sharedInstance;

//+ (instancetype)instance:(BOOL)createIfNil {
//    return createIfNil ? [self instance] : _sharedInstance;
//}
//
//+ (instancetype)instance {
//    if (! _sharedInstance) {
//        _sharedInstance = [self instanceWithFilterOptions:[MZLSharedData filterOptions]];
//    } else {
//        // 如果筛选条件更新，重新进行初始化
//        NSArray *filterOptions = [MZLSharedData filterOptions];
//        if (filterOptions != _sharedInstance.filterOptions) {
//            _sharedInstance = [self instanceWithFilterOptions:filterOptions];
//            // 重新设置selected filter item
//            [_sharedInstance setSelectedFilterOptions:[MZLSharedData selectedFilterOptions]];
//        }
//    }
//    return _sharedInstance;
//}

+ (instancetype)instanceWithFilterOptions:(NSArray *)filterOptions {
    if (! _sharedInstance) {
        _sharedInstance = [self _instanceWithFilterOptions:filterOptions];
    } else {
        // 如果筛选条件更新，需要重新更新filter option view
        if (! [MZLModelFilterType isFilterTypesTheSame:_sharedInstance.filterOptions anotherFilterTypeArray:filterOptions]) {
            [_sharedInstance createFilterOptionsViewWithFilterOptions:filterOptions];
        }
    }
    return _sharedInstance;
}

+ (instancetype)_instanceWithFilterOptions:(NSArray *)filterOptions {
    MZLFilterScrollView *filterScroll = [[MZLFilterScrollView alloc] initWithFrame:CGRectMake(CO_SCREEN_WIDTH, 0, WIDTH_MZL_FILTER_SCROLL_VIEW, CO_SCREEN_HEIGHT)];
    [filterScroll createFilterOptionsViewWithFilterOptions:filterOptions];
    return filterScroll;
}

#pragma mark - helper methods

- (void)setSelectedFilterOptions:(NSArray *)selectedFilterOptions {
    if (! selectedFilterOptions || selectedFilterOptions.count == 0) {
        return;
    }
    for (MZLFilterSectionView *sectionView in self.filterSections) {
        MZLModelFilterType *filter = sectionView.filterOptions;
        for (MZLModelFilterType *selected in selectedFilterOptions) {
            if (selected.identifier == filter.identifier) {
                // set selected
                [sectionView setSelectedFilterOptions:selected];
                break;
            }
        }
    }
}

- (void)resetFilterOptions {
    for (MZLFilterSectionView *sectionView in self.filterSections) {
        [sectionView resetFilterOptions];
    }
    [self onFilterModified];
}

- (NSArray *)removeUnnecesaryFilters:(NSArray *)filters {
    // 如果仅有一个filter且filterType为distance(全部)忽略此条件
    if (filters.count == 1) {
        MZLModelFilterType *filter = filters[0];
        if ([filter shouldIgnoreFilter]) {
            return [NSArray array];
        }
    }
    return filters;
}

#pragma mark - filter query success/failure callbacks

- (void)onFilterQuerySucceed {
//    [_indicator stopAnimating];
}

- (void)onFilterQueryFailed {
//    [_indicator stopAnimating];
}

#pragma mark - show/hide within current window

- (void)showWithDelegate:(id)delegate {
    self.delegate = delegate;
    if (! _swipeGestureForDelegate) {
        _swipeGestureForDelegate = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showFilterOptions)];
        _swipeGestureForDelegate.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    if ([self.delegate respondsToSelector:@selector(addSwipeGestureRecognizerToShowFilterOptions:)]) {
         [self.delegate addSwipeGestureRecognizerToShowFilterOptions:_swipeGestureForDelegate];
    }
    [IBMessageCenter addMessageListener:MZL_NOTIFICATION_FILTER_MODIFIED source:self target:delegate action:@selector(onFilterOptionsModified)];
    if (! self.superview) {
        UIWindow *window = globalWindow();
        [window addSubview:self];
    }
    [self show:YES];
}

- (void)hide {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(removeSwipeGestureRecognizer:)]) {
            [self.delegate removeSwipeGestureRecognizer:_swipeGestureForDelegate];
        }
        [IBMessageCenter removeMessageListener:MZL_NOTIFICATION_FILTER_MODIFIED source:self target:self.delegate];
    }
    self.delegate = nil;
    [self show:NO];
}

#define KEY_ANIMATION_SHOW @"KEY_ANIMATION_SHOW"

- (void)show:(BOOL)showFlag {
    // 显示用动画，隐藏不用动画
    if (showFlag) {
        [self co_animateFrameX:INITIAL_ORIGIN_X key:KEY_ANIMATION_SHOW];
    } else {
        [self pop_removeAnimationForKey:KEY_ANIMATION_SHOW];
        CGRect toFrame =  CGRectMake(CO_SCREEN_WIDTH, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
        self.frame = toFrame;
    }
}

@end
