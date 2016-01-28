//
//  MZLMyNormalTopBar.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-12.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLMyNormalTopBar.h"
#import "MZLSharedData.h"
#import "MZLAppNotices.h"
#import "UIView+MZLAdditions.h"

#define KEY_TAB_INDEX @"KEY_TAB_INDEX"

#define TAG_TAB 60
#define TAG_TAB_IMAGE 80
#define TAG_TAB_LBL 81

@interface MZLMyNormalTopBar () {
    NSArray *_myTabIndexes;
    NSArray *_myTabNames;
    NSArray *_myIcons;
    NSArray *_mySelectedIcons;
}

@property (weak, nonatomic) UIView *vwNoticeCounts;

@end

@implementation MZLMyNormalTopBar

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

+ (instancetype)tabBarInstance:(CGSize)parentViewSize{
    MZLMyNormalTopBar *result = [[[self class] alloc] init];
    result.frame = CGRectMake(0, 150, parentViewSize.width, MZLTopBarHeight);
    [result initInternal];
    return result;
}

- (void)initInternal {
    [self initConfig];
    [self initUI];
}

#pragma mark - config

- (NSArray *)tabNames {
    return @[@"想去", @"消息"];
}

- (NSArray *)tabIcons {
    return @[@"tab_my_want", @"tab_my_notice"];
}

- (NSArray *)tabSelectedIcons {
    return @[@"tab_my_want_sel", @"tab_my_notice_sel"];
}

- (NSArray *)tabIndexes {
    return @[@(MZL_MY_WANT_INDEX), @(MZL_MY_NOTIFICATION_INDEX)];
}

- (UIColor *)tabTitleDefaultColor {
    return @"B9B9B9".co_toHexColor;
}

- (UIColor *)tabTitleHighlightColor {
    return MZL_COLOR_YELLOW_FDD414();
}

- (void)initConfig {
    _myTabIndexes = [self tabIndexes];
    _myTabNames = [self tabNames];
    _myIcons = [self tabIcons];
    _mySelectedIcons = [self tabSelectedIcons];
}

#pragma mark - UI

- (void)initUI {
    [self createTabViews];
    [self initNoticeUI];
    [self updateUnreadCount];
    [self addBottomSeparator];
}

- (void)createTabViews {
    for (NSInteger i = 0; i <= _myTabNames.count - 1; i ++) {
        [self createTabViewWithIndex:i];
    }
}

- (UIView *)createTabViewWithIndex:(NSInteger)index {
    UIView *view = [self createSubView];
    [view setProperty:KEY_TAB_INDEX value:_myTabIndexes[index]];
    [view addTapGestureRecognizer:self action:@selector(onTabClicked:)];
    view.tag = TAG_TAB;
    
    NSString *tabTitle = _myTabNames[index];
    UIImageView *imageView = [view createSubViewImageView];
    imageView.tag = TAG_TAB_IMAGE;
    [[[imageView co_topParentWithOffset:2.0] co_width:24.0 height:24.0] co_centerXParent];
    UILabel *lbl = [view createSubViewLabelWithFontSize:12.0 textColor:[self tabTitleDefaultColor]];
    [[lbl co_topFromBottomOfView:imageView offset:1.0] co_centerXParent];
    lbl.text = tabTitle;
    lbl.tag = TAG_TAB_LBL;
    
    CGFloat width = floorf(self.width / _myTabNames.count);
    if (index == 0) {
        [view co_insetsParent:UIEdgeInsetsMake(0, 0, 0, COInvalidCons) width:width height:COInvalidCons];
    } else if (index == _myTabNames.count - 1) {
        [view co_insetsParent:UIEdgeInsetsMake(0, COInvalidCons, 0, 0)];
        [view co_leftFromRightOfPreSiblingWithOffset:0];
    } else {
        [view co_insetsParent:UIEdgeInsetsMake(0, COInvalidCons, 0, COInvalidCons) width:width height:COInvalidCons];
        [view co_leftFromRightOfPreSiblingWithOffset:0];
    }
    return view;
}

- (void)initNoticeUI {
    UIView *noticeTab = [self.subviews lastObject];
    UIView *view = [noticeTab createSubView];
    self.vwNoticeCounts = view;
    view.hidden =  YES;
    view.backgroundColor = @"FF243E".co_toHexColor;
    [view co_insetsParent:UIEdgeInsetsMake(2, COInvalidCons, COInvalidCons, COInvalidCons) width:24.0 height:24.0];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.superview.mas_centerX);
    }];
    
    UILabel *lblCount = [view createSubViewLabelWithFontSize:12.0 textColor:[UIColor whiteColor]];
    [lblCount co_centerParent];
    lblCount.text = @"0";
}

- (void)adjustNoticeCountUI {
    if (self.vwNoticeCounts.width > 0) {
        [self.vwNoticeCounts co_toRoundShapeWithDiameter:self.vwNoticeCounts.width];
    }
}

- (void)addBottomSeparator {
    UIView *sep = [self mzl_createTabSeparator];
    [sep co_bottomParent];
}

#pragma mark - events handler

- (void)onTabClicked:(UITapGestureRecognizer *)tap {
    UIView *tab = tap.view;
    NSNumber *tabIndex = [tab getProperty:KEY_TAB_INDEX];
    if (tabIndex) {
        NSInteger tabIndexValue = [tabIndex integerValue];
        if (self.delegate && [self.delegate respondsToSelector:@selector(onMyTopBarTabSelected:)]) {
            [self.delegate onMyTopBarTabSelected:tabIndexValue];
        }
    }
}

#pragma mark - misc

- (void)onTabSelected:(NSInteger)selectedTabIndex {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.subviews.count; i ++) {
        UIView *tab = self.subviews[i];
        if (tab.tag == TAG_TAB) {
            UIImageView *image = (UIImageView *)[tab viewWithTag:TAG_TAB_IMAGE];
            UILabel *lbl = (UILabel *)[tab viewWithTag:TAG_TAB_LBL];
            NSInteger tabIndex = [[tab getProperty:KEY_TAB_INDEX] integerValue];
            if (tabIndex == selectedTabIndex) {
                image.image = [UIImage imageNamed:_mySelectedIcons[index]];
                lbl.textColor = [self tabTitleHighlightColor];
            } else {
                image.image = [UIImage imageNamed:_myIcons[index]];
                lbl.textColor = [self tabTitleDefaultColor];
            }
            index ++;
        }
    }
}

- (void)updateUnreadCount{
    NSInteger unReadCount = [MZLAppNotices unReadMessageCount];
    UILabel *lblCount = [self.vwNoticeCounts.subviews lastObject];
    if (unReadCount > 0) {
        lblCount.text = [NSString stringWithFormat:@"%@",@(unReadCount)];
        if (unReadCount > 99) {
            lblCount.text = @"99+";
            [[self.vwNoticeCounts co_updateWidth:24.0] co_updateHeight:24.0];
        } else if (unReadCount > 10) {
            [[self.vwNoticeCounts co_updateWidth:22.0] co_updateHeight:22.0];
        } else {
            [[self.vwNoticeCounts co_updateWidth:20.0] co_updateHeight:20.0];
        }
        self.vwNoticeCounts.hidden = NO;
        [self.vwNoticeCounts setNeedsLayout];
        [self.vwNoticeCounts layoutIfNeeded];
        [self adjustNoticeCountUI];
    } else {
        self.vwNoticeCounts.hidden = YES;
    }
    
}
@end
