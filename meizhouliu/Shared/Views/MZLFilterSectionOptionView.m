//
//  MZLFilterSectionOptionView.m
//  Test
//
//  Created by Whitman on 14-9-10.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFilterSectionOptionView.h"
#import "MZLModelFilterItem.h"
#import <IBMessageCenter.h>

@interface MZLFilterSectionOptionView() {
    NSMutableArray * _btns;
}

@end

@implementation MZLFilterSectionOptionView

#pragma mark - protected

- (MZLModelFilterType *)selectedFilterOptions {
    NSMutableArray *selectedFilterItems = [NSMutableArray array];
    for (MZLFilterItemView *filterItemView in _btns) {
        if ([filterItemView isSelected]) {
            MZLModelFilterItem *item = [[MZLModelFilterItem alloc] init];
            item.identifier = filterItemView.tag;
            [selectedFilterItems addObject:item];
        }
    }
    if (selectedFilterItems.count > 0) {
        MZLModelFilterType *result = [self.filterOptions copy];
        result.items = selectedFilterItems;
        return result;
    }
    return nil;
}

- (void)initBottomView {
    _btns = [NSMutableArray array];
    NSMutableArray *btnGroup = [NSMutableArray array];
    NSMutableArray *btnGroupArray = [NSMutableArray array];
    void (^ addBtnGroup)(void) = ^ {
        WeView *btnGroupView = [[WeView alloc] init];
        [[btnGroupView addSubviewsWithHorizontalLayout:btnGroup]
         setHSpacing:10.0];
        [btnGroupArray addObject:btnGroupView];
        [btnGroup removeAllObjects];
    };
    for (int i = 1; i <= self.filterOptions.items.count; i ++) {
        MZLModelFilterItem *filterItem = self.filterOptions.items[i - 1];
        MZLFilterItemView *btn = [[MZLFilterItemView alloc] init];
        btn.delegate = self;
        [_btns addObject:btn];
        btn.tag = filterItem.identifier;
        [btn setText:filterItem.displayName];
        [btnGroup addObject:btn];
        if (i % 3 == 0) {
            addBtnGroup();
        }
    }
    if (btnGroup.count > 0) {
        addBtnGroup();
    }
    [[[[_bottom addSubviewsWithVerticalLayout:btnGroupArray]
     setVSpacing:12.0]
     setHMargin:MZL_FILTER_SECTION_VIEW_H_MARGIN]
     setHAlign:H_ALIGN_LEFT];
}

- (void)setSelectedFilterOptions:(MZLModelFilterType *)selectedFilterOptions {
    for (MZLFilterItemView *btn in _btns) {
        BOOL matched = NO;
        for (MZLModelFilterItem *item in selectedFilterOptions.items) {
            if (item.identifier == btn.tag) {
                matched = YES;
                break;
            }
        }
        [btn setSelected:matched];
    }
}

- (void)resetFilterOptions {
    for (MZLFilterItemView *btn in _btns) {
        [btn setSelected:NO];
    }
}

#pragma mark - delegate

- (void)onFilterOptionStateModified {
    // 有选项的状态发生变化，触发上层通知
    [IBMessageCenter sendMessageNamed:NOTI_FILTER_MODIFIED forSource:self];
}

@end
