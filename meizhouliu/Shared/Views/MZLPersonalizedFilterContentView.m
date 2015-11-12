//
//  MZLPersonalizedFilterContentView.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-12-15.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLPersonalizedFilterContentView.h"
#import <Masonry/Masonry.h>
#import <IBMessageCenter.h>
#import "MZLPersonalizedViewController.h"

@implementation MZLPersonalizedFilterContentView {
    __weak UIButton *_btnComplete;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - override

- (void)initFilterScroll {
    [super initFilterScroll];
    _filterScroll.backgroundColor = [UIColor whiteColor];
}

- (void)onInternalFilterModified {
    UIColor *color = colorWithHexString(@"#eeeeee");
    if ([self hasFilters]) {
        color = MZL_COLOR_YELLOW_FDD414();
    }
    [_btnComplete setBackgroundColor:color] ;
    [_btnComplete.layer setBorderColor:color.CGColor];

}

- (BOOL)hasFilterBar {
    return NO;
}

- (CGFloat)filterOptionsViewOriginX {
    return 0;
}

- (CGFloat)filterContentOriginX {
    return CO_SCREEN_WIDTH;
}

- (void)initCloseButton {
    // do not have close buttons;
}

- (void)initBottomButtons {
    UIButton *btnTabToExplore = [self createButtonWithTitle:@"随便逛逛" titleColor:colorWithHexString(@"#C9C9C9") borderColor:[UIColor clearColor] action:@selector(onSkipFilter)];
    UIButton *btnComplete = [self createButtonWithTitle:@"开启" titleColor:[UIColor whiteColor] borderColor:colorWithHexString(@"#eeeeee") action:@selector(onComplete)];
    [btnComplete setBackgroundColor:colorWithHexString(@"#eeeeee")];
    _btnComplete = btnComplete;
    
    for (UIButton *btn in @[btnTabToExplore, btnComplete]) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_vwFeature.mas_bottom).offset(36);
            make.width.equalTo(@72);
            make.height.equalTo(@24);
        }];
    }
    
    [btnTabToExplore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_vwContent).offset(16);
        
    }];
    
    [btnComplete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_vwContent).offset(-16);
    }];
    
    [_vwContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btnComplete.mas_bottom).offset(36);
    }];
}

- (NSString *)_filterTitle {
    return @"定制您的玩法";
}

- (void)initFilterTitle:(NSString *)title {
    UIView *_vwTitle = [self createViewWithParentView:_vwContent];
    [_vwTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.mas_equalTo(_vwContent);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *filterTitle = [self createLabelWithParentView:_vwTitle];
    [filterTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_vwTitle);
    }];
    
    [filterTitle setText:title];
    [filterTitle setFont:MZL_FONT(18)];
    [filterTitle setTextColor:MZL_COLOR_GRAY_7F7F7F()];
}

- (void)show:(BOOL)showFlag {
    if (showFlag) {
        [self showFilterOptions];
    } else {
        [self hideFilterOptions];
    }
}

#pragma mark - misc

- (void)onSkipFilter {
    [self hideFilterOptions];
    if (self.owner && [self.owner respondsToSelector:@selector(onSkipFilter)]) {
        [self.owner onSkipFilter];
    }
}

- (void)onComplete {
    if ([self hasFilters]) {
        [self onFilterModified];
    }
}

#pragma mark - public methods 

+ (instancetype)instanceWithFilterOptions:(NSArray *)filterOptions {
    MZLPersonalizedFilterContentView *filterView = [[MZLPersonalizedFilterContentView alloc] initWithFrame:CGRectMake(CO_SCREEN_WIDTH, 0, CO_SCREEN_WIDTH, CO_SCREEN_HEIGHT)];
    [filterView createFilterOptionsViewWithFilterOptions:filterOptions showDistanceFlag:YES];
    return filterView;
}

@end
