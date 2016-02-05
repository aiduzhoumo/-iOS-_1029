//
//  MZLMyFavoriteHeaderView.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/18.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import "MZLMyFavoriteHeaderView.h"

#import "UIView+MZLAdditions.h"
#import "MZLAppNotices.h"
#import "MZLModelUser.h"
#import "UIImageView+MZLNetwork.h"

#define KEY_TAB_INDEX @"KEY_TAB_INDEX"

#define TAG_TAB 60
#define TAG_TAB_IMAGE 80
#define TAG_TAB_LBL 81

@interface MZLMyFavoriteHeaderView () {
    NSArray *_myTabIndexes;
    NSArray *_myTabNames;
    NSArray *_myIcons;
    NSArray *_mySelectedIcons;
}
@property (weak, nonatomic) UIView *vwNoticeCounts;

@end

@implementation MZLMyFavoriteHeaderView

+ (instancetype)myFavoriteHeaderViewInstance:(CGSize)parentViewSize{
    
//    MZLMyNormalFavoriteHeaderView *headerView = [[[self class] alloc] init];
//    headerView = [MZLMyNormalFavoriteHeaderView viewFromNib:@"MZLMyNormalFavoriteHeaderView"];
//    
//    headerView.frame = CGRectMake(0, 0, parentViewSize.width, MZLMyFavoriteHeaderViewHeight);
//    //    headerView.backgroundColor = [UIColor redColor];
//    [headerView initInternal];
    return nil;
}

- (void)initWithMyFavoriteHeaderView {
    [self initInternal];
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
    [self createUserHeaderIcon];
    [self createTabViews];
    [self initNoticeUI];
    [self updateUnreadCount];
    [self updateUserInfo:_user];
    [self addBottomSeparator];
}

- (void)createUserHeaderIcon {
    [self.userHeadIcon toRoundShape];
}

- (void)createTabViews {
    for (NSInteger i = 0; i <= _myTabNames.count - 1; i ++) {
        [self createTabViewWithIndex:i];
    }
}

- (UIView *)createTabViewWithIndex:(NSInteger)index {
    UIView *view = [self.topVIew createSubView];
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
    UIView *noticeTab = [self.topVIew.subviews lastObject];
    UIView *view = [noticeTab createSubView];
    self.vwNoticeCounts = view;
    view.hidden =  YES;
    view.backgroundColor = @"FF243E".co_toHexColor;
    [view co_insetsParent:UIEdgeInsetsMake(2, COInvalidCons, COInvalidCons, COInvalidCons) width:24.0 height:24.0];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.superview.mas_centerX);
    }];
    
    UILabel *lblCount = [view createSubViewLabelWithFontSize:13.0 textColor:[UIColor whiteColor]];
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(onMyFavoriteHeaderViewTopBarSelected:)]) {
            [self.delegate onMyFavoriteHeaderViewTopBarSelected:tabIndexValue];
        }
    }
}

#pragma mark - misc

- (void)onTabSelected:(NSInteger)selectedTabIndex {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.topVIew.subviews.count; i ++) {
        UIView *tab = self.topVIew.subviews[i];
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

- (void)updateUserInfo:(MZLModelUser *)user {
    
    _user = user;
    
    if (_user) {
        [self.userHeadIcon loadAuthorImageFromURL:_user.photoUrl];
        [self.userHeadIcon addTapGestureRecognizer:self action:@selector(onHeaderClick:)];
        self.userName.text = _user.nickName;
        self.attentionCount.text = _user.followees_count;
        [self.attentionCount addTapGestureRecognizer:self action:@selector(toFeriendAttentionListView:)];
        [self.attentionLbl addTapGestureRecognizer:self action:@selector(toFeriendAttentionListView:)];
        self.fensiCount.text = _user.followers_count;
        [self.fensiCount addTapGestureRecognizer:self action:@selector(toFeriendFensiListView:)];
        [self.fensiLbl addTapGestureRecognizer:self action:@selector(toFeriendFensiListView:)];
        self.userIntroductionLbl.text = [NSString stringWithFormat:@"%@",_user.introduction];
    }
    
}

#pragma mark - tap
- (void)onHeaderClick:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(toAuthorDetailVc)]) {
        [self.delegate toAuthorDetailVc];
    }
}
- (void)toFeriendAttentionListView:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(toFeriendListVc:)]) {
        [self.delegate toFeriendListVc:feriendKindListAttention];
    }
}
- (void)toFeriendFensiListView:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(toFeriendListVc:)]) {
        [self.delegate toFeriendListVc:feriendKindListFensi];
    }
}

@end
