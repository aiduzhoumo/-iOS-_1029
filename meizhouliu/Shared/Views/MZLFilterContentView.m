//
//  MZLFilterContentView.m
//  mzl_mobile_ios
//
//  Created by race on 14/11/17.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFilterContentView.h"

#import <Masonry/Masonry.h>
#import <POPSpringAnimation.h>
#import <IBMessageCenter.h>
#import "UIView+COPopAdditions.h"
#import "UIView+MBProgressHUDAdditions.h"

#import "MZLModelFilterItem.h"

#import "MZLFilterBar.h"
#import "MZLFilterCrowdSectionView.h"
#import "MZLFilterFeatureSectionView.h"
#import "MZLFilterSectionDistanceView.h"
#import "MZLLocationDetailViewController.h"
#import "UIView+MZLAdditions.h"
#import "MZLFilterDistanceView.h"

//#define WIDTH_MZL_FILTER_SCROLL_VIEW CO_SCREEN_WIDTH + WIDTH_MZL_FILTER_BAR
//#define INITIAL_ORIGIN_X (CO_SCREEN_WIDTH - WIDTH_MZL_FILTER_BAR)
//#define SHOW_FILTER_OPTIONS_ORIGIN_X (-WIDTH_MZL_FILTER_BAR)
//#define WIDTH_LEFT_VIEW SHOW_FILTER_OPTIONS_ORIGIN_X

@interface MZLFilterContentView () {
    BOOL _showDistance;
    NSArray *_intersected;
    NSTimer *_timer;
    NSTimer *_transparentTimer;
    UISwipeGestureRecognizer *_swipeGestureForDelegate;
    NSDate *_filterModifiedTimeStamp;
    NSMutableArray * _itmes;
    __weak MZLFilterBar *_filterBar;
   
//    __weak UIButton *btnComplete;
//    __weak UIButton *btnClearAll;
    
}

@property (assign, nonatomic) BOOL showDistance;
//@property (weak, readonly) UIView *vwContent;
@property (strong, nonatomic) UIView *vwDistance;
@property (strong, nonatomic) UIView *vwPeople;
//@property (strong, nonatomic) UIView *vwFeature;

//@property (nonatomic, strong) NSArray *filterSections;


@end

@implementation MZLFilterContentView

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

- (void)initInternal {
    _filterSectionViews = [NSMutableArray array];
    [self initFilterScroll];
    [self initFilterBar];
    [self addGlobalMsgListener];
}

- (void)addGlobalMsgListener {
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_FILTER_MODIFIED target:self action:@selector(toggleFilterBarStatus)];
//    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_FILTER_QUERY_SUCCEED target:self action:@selector(onFilterQuerySucceed)];
//    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_FILTER_QUERY_FAILED target:self action:@selector(onFilterQueryFailed)];
}

- (void)toggleFilterBarStatus {
    if ([self hasFilterBar]) {
        NSArray *selected = [MZLSharedData selectedFilterOptions];
        selected = [self removeUnnecesaryFilters:selected];
        [_filterBar toggleFilterImage:selected.count > 0];
    }
}

#pragma mark - UI 

- (void)initFilterScroll {
    UIScrollView *filterScroll = [self createScrollWithParentView:self];
    _filterScroll = filterScroll;
    [filterScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.and.right.mas_equalTo(filterScroll.superview);
        if ([self hasFilterBar]) {
            make.left.equalTo(self.mas_left).offset(WIDTH_MZL_FILTER_BAR);
        } else {
            make.left.equalTo(self.mas_left);
        }
    }];
    filterScroll.backgroundColor = [UIColor whiteColor];
}

- (NSString *)_filterTitle {
    return @"";
}

- (void)initFilterOptionsView {
    [self initFilterOptionsContent];
    [self initFilterTitle:[self _filterTitle]];
    [self initFilterSections];
    [self initFilterButtons];
}

- (void)initFilterOptionsContent {
    _vwContent = [_filterScroll createSubView];
    [_vwContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_vwContent.superview);
        make.width.equalTo(_vwContent.superview);
    }];
}

- (void)initFilterSections {
    if (self.showDistance) {
        [self initDistanceView];
    }
    [self initCrowdView];
    [self initFeatureView];
    for (UIView *section in _filterSectionViews) {
        [IBMessageCenter addMessageListener:NOTI_FILTER_MODIFIED source:section target:self action:@selector(onInternalFilterModified)];
    }
}

- (void)onInternalFilterModified {
}

- (void)initFilterButtons {
    [self initButtons];
}

- (BOOL)hasFilterBar {
    return YES;
}

- (void)initFilterBar {
    if (! [self hasFilterBar]) {
        return;
    }
    //add filterBar
    MZLFilterBar *filterBar = [UIView viewFromNib:@"MZLFilterBar"];
    _filterBar = filterBar;
    [self addSubview:filterBar];
    [filterBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(95);
        make.width.mas_equalTo(WIDTH_MZL_FILTER_BAR);
        make.left.mas_equalTo(self.mas_left);
    }];
    [self makeFilterBarTransparent:YES animatedFlag:NO];
    [filterBar addTapGestureRecognizer:self action:@selector(toggleTranslation)];
}

- (void)createFilterOptionView {
    [self initFilterOptionsView];
}

- (void)initFilterTitle:(NSString *)title {
}

#pragma mark - 初始化筛选项 距离设置选项view

- (void)initDistanceView {
    //距离view通过weview创建，需要在外面嵌套一层view来约束它所显示的位置
    for (MZLModelFilterType *filterType in [self _filterOptions]) {
        if (filterType.identifier == MZLFilterTypeDistance) {
            UIView *vwDistance = [self createView:[MZLFilterDistanceView class] parent:_vwContent];
            self.vwDistance = vwDistance;
            [vwDistance mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_vwContent.top).offset(32);
                make.left.mas_equalTo(_vwContent.mas_left);
                make.right.mas_equalTo(_vwContent.mas_right);
                make.height.equalTo(@119);
            }];
            MZLFilterSectionDistanceView *section = [[MZLFilterSectionDistanceView alloc] initWithFilterOptions:filterType];
            [vwDistance addSubview:section];
            [section mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(vwDistance);
            }];
            [_filterSectionViews addObject:section];
            break;
        }
    }
//    [IBMessageCenter addMessageListener:NOTI_FILTER_MODIFIED source:section target:self action:@selector(onFilterModified)];
}


#pragma mark - 初始化筛选项 人群选项view

- (void)initCrowdView {
    
    MZLFilterSectionBaseView *sectionView;
    for (MZLModelFilterType *filterType in [self _filterOptions]) {
        if (filterType.identifier == MZLFilterTypePeople) {
            sectionView = [[MZLFilterCrowdSectionView alloc] initWithFilterOptions:filterType];
            [_vwContent addSubview:sectionView];
        }
    }
    
    [sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.showDistance) {
            sectionView.topLine.visible = YES;
            make.top.equalTo(self.vwDistance.mas_bottom);
        }else {
            sectionView.topLine.visible = NO;
            make.top.mas_equalTo(_vwContent.top).offset(32);
        }
        make.left.equalTo(_vwContent.mas_left);
        make.right.equalTo(_vwContent.mas_right);
    }];
    
    self.vwPeople = sectionView;
    [_filterSectionViews addObject:sectionView];
//    [IBMessageCenter addMessageListener:NOTI_FILTER_MODIFIED source:sectionView target:self action:@selector(onFilterModified)];
}


#pragma mark - 初始化筛选项 特征选项view

- (void)initFeatureView{
    MZLFilterSectionBaseView *sectionView;
    for (MZLModelFilterType *filterType in [self _filterOptions]) {
        if (filterType.identifier == MZLFilterTypeFeature) {
            sectionView  = [[MZLFilterFeatureSectionView alloc] initWithFilterOptions:filterType];
            [_vwContent addSubview:sectionView];
        }
    }
    
    [sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vwPeople.mas_bottom);
        make.left.equalTo(_vwContent.mas_left);
        make.right.equalTo(_vwContent.mas_right);
    }];
    
    _vwFeature = sectionView;
    [_filterSectionViews addObject:sectionView];
//    [IBMessageCenter addMessageListener:NOTI_FILTER_MODIFIED source:sectionView target:self action:@selector(onFilterModified)];
}

#pragma mark - init buttons

- (void)initButtons {
    [self initCloseButton];
    [self initBottomButtons];
}

- (UIButton *)createButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor borderColor:(UIColor *)borderColor action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    [_vwContent addSubview:button];
    button.layer.borderWidth = 0.5;
    button.layer.cornerRadius = 3;
    button.titleLabel.font = MZL_FONT(14);
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal] ;
    [button.layer setBorderColor:borderColor.CGColor];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)initCloseButton {
    UIView *vwBtn = [self createViewWithParentView:_vwContent];
    [vwBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_vwContent.mas_top).offset(15);
        make.right.equalTo(_vwContent.mas_right);
        make.width.equalTo(@48);
        make.height.equalTo(@48);
    }];
    [vwBtn addTapGestureRecognizer:self action:@selector(closeFilterView)];
    UIButton *btnClose = [self createButtonWithParentView:vwBtn];
    [btnClose addTarget:self action:@selector(closeFilterView) forControlEvents:UIControlEventTouchDown];
    [btnClose setImage:[UIImage imageNamed:@"Filter_Close"] forState:UIControlStateNormal] ;
    [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_vwContent.mas_top).offset(36);
        make.right.equalTo(_vwContent.mas_right).offset(-15);
    }];
}

- (void)initBottomButtons {
    UIButton *btnClearAll = [self createButtonWithTitle:@"清除条件" titleColor:colorWithHexString(@"#C9C9C9") borderColor:colorWithHexString(@"#C9C9C9") action:@selector(resetFilterOptions)];
    UIButton *btnComplete = [self createButtonWithTitle:@"完成" titleColor:MZL_COLOR_YELLOW_FDD414() borderColor:MZL_COLOR_YELLOW_FDD414() action:@selector(onFilterModified)];

    for (UIButton *btn in @[btnClearAll, btnComplete]) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_vwFeature.mas_bottom).offset(36);
            make.width.equalTo(@72);
            make.height.equalTo(@24);
        }];
    }
    
    [btnClearAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_vwContent).offset(16);
       
    }];
    
    [btnComplete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_vwContent).offset(-16);
    }];
    
    [_vwContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btnComplete.mas_bottom).offset(36);
    }];
}

- (void)closeFilterView {
    [ self hideFilterOptions];
}

#pragma mark - filter query success/failure callbacks

- (void)onFilterQuerySucceed {
    //    [_indicator stopAnimating];
}

- (void)onFilterQueryFailed {
    //    [_indicator stopAnimating];
}


- (NSArray *)_filterOptions {
    return [MZLSharedData filterOptions];
}

#pragma mark - filter bar show/transparent

- (void)makeFilterBarTransparent:(BOOL)transparentFlag animatedFlag:(BOOL)animatedFlag {
    if (!  [self hasFilterBar]) {
        return;
    }
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
        [self makeFilterBarTransparent:NO animatedFlag:NO];
        if ([self.delegate respondsToSelector:@selector(onFilterOptionsWillShow)]) {
            [self.delegate onFilterOptionsWillShow];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(onFilterOptionsWillHide)]) {
            [self.delegate onFilterOptionsWillHide];
        }
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:showFlag withAnimation:UIStatusBarAnimationFade];
    CGFloat toX = showFlag ? [self filterOptionsViewOriginX] : [self filterContentOriginX];
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
            [self refreshSelectedFilterOptions:self.filterOptions];
            if ([self.delegate respondsToSelector:@selector(onFilterOptionsShown)]) {
                [self.delegate onFilterOptionsShown];
            }
        } else {
            [self resetFilterOptions];
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
    [self hideFilterOptions];
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
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(sendFilterMessage) userInfo:nil repeats:NO];
}

- (void)sendFilterMessage {
    _timer = nil;
//    [IBMessageCenter sendMessageNamed:MZL_NOTIFICATION_FILTER_MODIFIED forSource:self];
    [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_FILTER_MODIFIED];
}

#pragma mark - positions 

//- (CGFloat)filterContentWidth {
//    return CO_SCREEN_WIDTH + WIDTH_MZL_FILTER_BAR;
//}

- (CGFloat)filterOptionsViewOriginX {
    return -WIDTH_MZL_FILTER_BAR;
}

- (CGFloat)filterContentOriginX {
    return CO_SCREEN_WIDTH - WIDTH_MZL_FILTER_BAR;
}

#pragma mark - public methods

- (BOOL)isFilterOptionsVisible {
    return self.x <= [self filterOptionsViewOriginX];
}

- (NSArray *)selectedFilterOptions {
    NSMutableArray *result = [NSMutableArray array];
    for (MZLFilterSectionBaseView *sectionView in _filterSectionViews) {
        MZLModelFilterType *filter = [sectionView selectedFilterOptions];
        if (filter) {
            [result addObject:filter];
        }
    }
    return result;
}

static MZLFilterContentView *_sharedInstance;

+ (instancetype)instanceWithFilterOptions:(NSArray *)filterOptions showDistanceFlag:(BOOL)flag {
    if (! _sharedInstance) {
        _sharedInstance = [self _instanceWithFilterOptions:filterOptions showDistanceFlag:flag];
    } else {
        // 如果筛选条件更新，需要重新更新filter option view
        if (! [MZLModelFilterType isFilterTypesTheSame:_sharedInstance.filterOptions anotherFilterTypeArray:filterOptions]) {
            [_sharedInstance createFilterOptionsViewWithFilterOptions:filterOptions showDistanceFlag:flag];
        }
    }
    return _sharedInstance;
}

+ (instancetype)_instanceWithFilterOptions:(NSArray *)filterOptions showDistanceFlag:(BOOL)flag {
    MZLFilterContentView *filterView = [[MZLFilterContentView alloc] initWithFrame:CGRectMake(CO_SCREEN_WIDTH - WIDTH_MZL_FILTER_BAR, 0, CO_SCREEN_WIDTH + WIDTH_MZL_FILTER_BAR, CO_SCREEN_HEIGHT)];
    [filterView createFilterOptionsViewWithFilterOptions:filterOptions showDistanceFlag:flag];
    return filterView;
}


- (void)createFilterOptionsViewWithFilterOptions:(NSArray *)filterOptions showDistanceFlag:(BOOL)flag{
    self.filterOptions = filterOptions;
    self.showDistance = flag;
    if (_vwContent) {
        [_filterSectionViews removeAllObjects];
        [_vwContent removeFromSuperview];
    }
    [self createFilterOptionView];
    NSArray *selected = [MZLSharedData selectedFilterOptions];
    _intersected = [MZLModelFilterType intersectFilterTypesFromA:selected withB:filterOptions];
    [_filterBar toggleFilterImage:_intersected.count > 0];
}

- (void)refreshSelectedFilterOptions:(NSArray *)filterOptions {
    NSArray *selected = [MZLSharedData selectedFilterOptions];
    _intersected = [MZLModelFilterType intersectFilterTypesFromA:selected withB:filterOptions];
    _intersected = [self removeUnnecesaryFilters:_intersected];
    [self setSelectedFilterOptions:_intersected];
}

- (void)toggleTranslation {
    if ([UIView isProgressIndicatorVisible]) { // 当前有活跃的service
        return;
    }
    [self showFilterOptions:! [self isFilterOptionsVisible]];
}


#pragma mark - helper methods

- (void)setSelectedFilterOptions:(NSArray *)selectedFilterOptions {
    if (! selectedFilterOptions || selectedFilterOptions.count == 0) {
        return;
    }
    for (MZLFilterSectionBaseView *sectionView in _filterSectionViews) {
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
    for (MZLFilterSectionBaseView *sectionView in _filterSectionViews) {
        [sectionView resetFilterOptions];
    }
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

- (BOOL)hasFilters {
    NSArray *temp = [self removeUnnecesaryFilters:[self selectedFilterOptions]];
    return temp.count > 0;
}

#pragma mark - show/hide within current window

- (void)showWithDelegate:(id)delegate {
    self.delegate = delegate;
    if (! _swipeGestureForDelegate) {
        _swipeGestureForDelegate = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showFilterOptions)];
        _swipeGestureForDelegate.direction = UISwipeGestureRecognizerDirectionLeft;
    }
//    if ([self.delegate respondsToSelector:@selector(addSwipeGestureRecognizerToShowFilterOptions:)]) {
//        [self.delegate addSwipeGestureRecognizerToShowFilterOptions:_swipeGestureForDelegate];
//    }
//    [IBMessageCenter addMessageListener:MZL_NOTIFICATION_FILTER_MODIFIED source:self target:delegate action:@selector(onFilterOptionsModified)];
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_FILTER_MODIFIED target:delegate action:@selector(onFilterOptionsModified)];
    if (! self.superview) {
        UIWindow *window = globalWindow();
        [window addSubview:self];
    }
    [self show:YES];
}

- (void)hide {
    if (self.delegate) {
//        if ([self.delegate respondsToSelector:@selector(removeSwipeGestureRecognizer:)]) {
//            [self.delegate removeSwipeGestureRecognizer:_swipeGestureForDelegate];
//        }
//        [IBMessageCenter removeMessageListener:MZL_NOTIFICATION_FILTER_MODIFIED source:self target:self.delegate];
        [IBMessageCenter removeMessageListener:MZL_NOTIFICATION_FILTER_MODIFIED source:nil target:self.delegate];
    }
    self.delegate = nil;
    [self show:NO];
}

#define KEY_ANIMATION_SHOW @"KEY_ANIMATION_SHOW"

- (void)show:(BOOL)showFlag {
    // 显示用动画，隐藏不用动画
    if (showFlag) {
        [self co_animateFrameX:[self filterContentOriginX] key:KEY_ANIMATION_SHOW];
    } else {
        [self pop_removeAnimationForKey:KEY_ANIMATION_SHOW];
        CGRect toFrame =  CGRectMake(CO_SCREEN_WIDTH, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
        self.frame = toFrame;
    }
}


@end
