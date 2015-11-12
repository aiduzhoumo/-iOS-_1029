//
//  MZLFilterSectionScrollView.h
//  mzl_mobile_ios
//
//  Created by race on 14/11/19.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFilterView.h"
#import "MZLFilterItemWithLabel.h"
#import "MZLModelFilterType.h"

#define NOTI_FILTER_MODIFIED @"NOTI_FILTER_MODIFIED"

@class MZLModelFilterType;

@interface MZLFilterSectionBaseView : MZLFilterView <MZLFilterItemDelegate>

@property (nonatomic, strong) NSMutableArray * sectionBtns;
@property (nonatomic, strong) MZLModelFilterType *filterOptions;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *topLine;

- (MZLModelFilterType *)selectedFilterOptions;
- (void)setSelectedFilterOptions:(MZLModelFilterType *)selectedFilterOptions;
- (void)resetFilterOptions;

- (instancetype)initWithFilterOptions:(MZLModelFilterType *)filterOptions;

- (void)initSectionTitle:(NSString *)title image:(UIImage *)image;

/** 筛选图片类型的标签 **/
-(NSArray *)filterItemWithType:(NSInteger)type;

@end
