//
//  MZLFeriendListViewController.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/6.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import "MZLFeriendListViewController.h"
#import <Masonry/Masonry.h>
#import "MZLBaseViewController+CityList.h"
#import "UIViewController+MZLAdditions.h"
#import <IBMessageCenter.h>
#import "MZLTableViewController.h"
#import "UIView+MZLAdditions.h"
#import "MZLFensiListViewController.h"
#import "MZLAttentionListViewController.h"
#import "MZLServices.h"

#define TAG_ATTENTION_LIST 199
#define TAG_FENSI_LIST 200
#define TITLE_FONT_SIZE 14.0

typedef void(^ MZL_SVC_TEXT_BLOCK)(MZLModelUser *user);

@interface MZLFeriendListViewController ()
{
    UIViewController *_childAttentionListVC;
    UIViewController *_childFensiListVC;
    __weak UIViewController *_selectedChildVC;
    __weak UIView *_vwTabHeader;
    __weak UIView *vwCenter;
    __weak UILabel *_leftTitleLbl;
    __weak UILabel *_rightTitleLbl;
    __weak UILabel *_selectedTitleLbl;
    __weak UIView *_titleIndicator;
    __weak MASViewConstraint *_indicatorCentenXCons;
}
@end

@implementation MZLFeriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"好友列表";
        
    MZLAttentionListViewController *attentionList = [MZL_MAIN_STORYBOARD() instantiateViewControllerWithIdentifier:@"MZLAttentionListViewController"];
    attentionList.user = self.user;
    _childAttentionListVC = attentionList;
    MZLFensiListViewController *fensiList = [MZL_MAIN_STORYBOARD() instantiateViewControllerWithIdentifier:@"MZLFensiListViewController"];
    fensiList.user = self.user;
    _childFensiListVC = fensiList;
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.listKind == seleFeriendListKindAttention) {
        [self switchToChildVCWithTag:TAG_ATTENTION_LIST];
    }else if (self.listKind == seleFeriendListKindFensi){
        [self switchToChildVCWithTag:TAG_FENSI_LIST];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initUI

- (void)initUI {
    [self initHeaderTabBar];
    [self initContentView];
}

- (void)initContentView {
    UIView *contentView = [self.contentView createSubView];
    _contentView = contentView;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(contentView.superview);
        make.top.mas_equalTo(_vwTabHeader.mas_bottom);
    }];
}

- (void)initHeaderTabBar {
    UIView *headerTaBar = [self.contentView createSubView];
    _vwTabHeader = headerTaBar;
    [headerTaBar co_insetsParent:UIEdgeInsetsMake(0, 0, COInvalidCons, 0) width:COInvalidCons height:40.0];
    
    CGFloat spacing = 80.0;
    UIView *headerTabCenter = [[headerTaBar createSubView] co_insetsParent:UIEdgeInsetsMake(0, COInvalidCons, 0, COInvalidCons)];
    [headerTabCenter co_centerXParent];
    UILabel *leftLbl = [headerTabCenter createSubViewLabelWithFont:MZL_BOLD_FONT(TITLE_FONT_SIZE) textColor:@"FFD414".co_toHexColor];
    leftLbl.text = @"关注";
    [leftLbl co_insetsParent:UIEdgeInsetsMake(0, COInvalidCons, 0, COInvalidCons)];
    [leftLbl co_leftParentWithOffset:spacing / 2.0];
    UILabel *rightLbl = [headerTabCenter createSubViewLabelWithFontSize:TITLE_FONT_SIZE textColor:@"434343".co_toHexColor];
    rightLbl.text = @"粉丝";
    [rightLbl co_insetsParent:UIEdgeInsetsMake(0, COInvalidCons, 0, COInvalidCons)];
    [rightLbl co_rightParentWithOffset:spacing / 2.0];
    [rightLbl co_leftFromRightOfPreSiblingWithOffset:spacing];
    UIView *indicator = [[[headerTabCenter createSubView] co_bottomParent] co_width:80.0 height:4.0];
    indicator.backgroundColor = @"FFD414".co_toHexColor;
    NSArray *constraints = [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(leftLbl.mas_centerX);
    }];
    _indicatorCentenXCons = constraints[0];
    UIView *bottomView = [[[headerTabCenter createSubView] co_bottomParent] co_width:CO_SCREEN_WIDTH height:1.0];
    bottomView.backgroundColor = @"D8D8D8".co_toHexColor;
    leftLbl.tag = TAG_ATTENTION_LIST;
    rightLbl.tag = TAG_FENSI_LIST;
    [leftLbl addTapGestureRecognizer:self action:@selector(onTitleLableClick:)];
    [rightLbl addTapGestureRecognizer:self action:@selector(onTitleLableClick:)];
    _titleIndicator = indicator;
    _leftTitleLbl = leftLbl;
    _rightTitleLbl = rightLbl;
    _selectedTitleLbl = leftLbl;
}

- (void)onTitleLableClick:(UITapGestureRecognizer *)tap {
    UILabel *lbl = (UILabel *)(tap.view);
    [self switchToChildVCWithTag:lbl.tag];
}

- (void)indicatorAnimation {
    [_indicatorCentenXCons uninstall];
    NSArray *constraints = [_titleIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_selectedTitleLbl.mas_centerX);
    }];
    _indicatorCentenXCons = constraints[0];
    [UIView animateWithDuration:0.3 animations:^{
        [_vwTabHeader layoutIfNeeded];
    }];
}

- (void)toggleTitleLable:(NSInteger)tag {
    UILabel *toLable = (tag == TAG_ATTENTION_LIST) ? _leftTitleLbl : _rightTitleLbl;
    if (_selectedTitleLbl == toLable) {
        return;
    }
    _selectedTitleLbl.font = MZL_FONT(TITLE_FONT_SIZE);
    _selectedTitleLbl.textColor = @"434343".co_toHexColor;
    toLable.font = MZL_BOLD_FONT(TITLE_FONT_SIZE);
    toLable.textColor = @"FFD414".co_toHexColor;
    _selectedTitleLbl = toLable;
    [self performSelector:@selector(indicatorAnimation) withObject:nil afterDelay:0.3];
}

#pragma mark - childVC switch

- (void)switchToChildVCWithTag:(NSInteger)tag {
    [self toggleTitleLable:tag];
    UIViewController *toVc = (tag == TAG_ATTENTION_LIST) ? _childAttentionListVC : _childFensiListVC;
    if (toVc == _selectedChildVC) {
        return;
    }
    self.listKind = (tag == TAG_ATTENTION_LIST) ? seleFeriendListKindAttention : seleFeriendListKindFensi;
    _selectedChildVC = toVc;
    [self mzl_flipToChildViewController:_selectedChildVC inView:_contentView];
    [_selectedChildVC mzl_onWillBecomeTabVisibleController];
}

#pragma mark - override

- (void)mzl_onWillBecomeTabVisibleController {
    [_selectedChildVC mzl_onWillBecomeTabVisibleController];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
