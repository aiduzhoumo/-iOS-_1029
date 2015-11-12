//
//  MZLFilterSectionScrollView.m
//  mzl_mobile_ios
//
//  Created by race on 14/11/19.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFilterSectionBaseView.h"
#import <Masonry/Masonry.h>
#import "MZLModelFilterItem.h"
#import "MZLModelFilterType.h"
#import "MZLFilterItemWithLabel.h"
#import <IBMessageCenter.h>

@implementation MZLFilterSectionBaseView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initInternal {
    
    self.sectionBtns = [NSMutableArray array];
    [self initSeparetorLine];
    
    //创建一个scrollView，scrollView包含一个contentView
    self.scrollView = [self createScrollWithParentView:self];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.contentView = [self createViewWithParentView:self.scrollView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
}

//初始化顶部分割线
- (void)initSeparetorLine {
    UIView *topLine = [self createViewWithParentView:self];
    topLine.backgroundColor = colorWithHexString(@"#cccccc");
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@0.5);
    }];
    self.topLine = topLine;
}

#pragma mark - 初始化各筛选项的标题

- (void)initSectionTitle:(NSString *)title image:(UIImage *)image {
    UIImageView *topLeftImageView = [self createImageViewWithParentView:self];
    topLeftImageView.image = image;
    [topLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(16);
        make.left.equalTo(self.mas_left).offset(16);
    }];
    
    UILabel *topLeftTitle = [self createLabelWithParentView:self];
    topLeftTitle.text = title;
    topLeftTitle.font = MZL_FONT(14);
    topLeftTitle.textColor = MZL_COLOR_YELLOW_FDD414();
    [topLeftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topLeftImageView.mas_right).offset(4);
        make.centerY.equalTo(topLeftImageView);
    }];
}


#pragma mark - filter instancetype

- (instancetype)initWithFilterOptions:(MZLModelFilterType *)filterOptions {
    self.filterOptions = filterOptions;
    self = [super init];
    return self;
}


- (NSArray *)filterItemWithType:(NSInteger)type {
    NSMutableArray *items = [NSMutableArray array];
    for (MZLModelFilterItem *filterItem in self.filterOptions.items) {
        if (filterItem.itemType == type) {
            [items addObject:filterItem];
        }
    }
    return items;
}


#pragma mark - protected

- (MZLModelFilterType *)selectedFilterOptions {
    NSMutableArray *selectedFilterItems = [NSMutableArray array];
    for (MZLFilterItemWithLabel *itemWithImage in self.sectionBtns) {
        if ([itemWithImage isSelected]) {
            MZLModelFilterItem *item = [[MZLModelFilterItem alloc] init];
            item.identifier = itemWithImage.tag;
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

- (void)setSelectedFilterOptions:(MZLModelFilterType *)selectedFilterOptions {
    for (MZLFilterItemWithLabel *btn in self.sectionBtns) {
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
    for (MZLFilterItemWithLabel *filterItem in self.sectionBtns) {
        [filterItem setSelected:NO];
    }
}

#pragma mark - delegate
- (void)onFilterOptionStateModified {
    // 有选项的状态发生变化，触发上层通知
    [IBMessageCenter sendMessageNamed:NOTI_FILTER_MODIFIED forSource:self];
}

@end
