//
//  MZLFilterFeatureSection.m
//  mzl_mobile_ios
//
//  Created by race on 14/11/19.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFilterFeatureSectionView.h"

#import "MZLFilterItemWithImage.h"
#import "MZLFilterItemWithLabel.h"
#import "MZLModelFilterType.h"
#import "MZLModelFilterItem.h"

#import <Masonry/Masonry.h>

@interface MZLFilterFeatureSectionView() {
    UIView* _contentView;
    UIView *vwImageHolder ;
    UIView *vwLableHolder;
    UIView *vwSeparetorLine;
    
}

@end
@implementation MZLFilterFeatureSectionView

- (void)initInternal {
    [super initInternal];
    [self initSectionTitle:@"玩什么" image:[UIImage imageNamed:@"Filter_Feature"]];
    _contentView = self.contentView;
    
    //往contentView内添加内容
    [self addLeftView];
    [self addSeparatorLineInContentView];
    [self addRightView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(vwLableHolder.mas_right).offset(24);
    }];
}


#pragma mark - init UI

//标签带图标
- (void)addLeftView {
    [self initViewWithImageHolder];
}

//添加scrollView 内部带图标标签与普通标签的分割线
- (void)addSeparatorLineInContentView {
    [self initSeparatorLineInContentView];
}

//标签不带图标
- (void)addRightView {
    [self initViewWithLableHolder];
}


- (void)initViewWithImageHolder {
    NSArray *items = [self filterItemWithType:MZLFilterItemTypeImage];
    vwImageHolder = [self createViewWithParentView:_contentView];
    UIView *lastView;
    for (int i = 0; i < items.count; i++) {
        MZLModelFilterItem *filterItem = items[i];
        MZLFilterItemWithImage *itemWithImage = [self createView:[MZLFilterItemWithImage class] parent:vwImageHolder];
        itemWithImage.delegate = self;
        itemWithImage.tag = filterItem.identifier;
        [itemWithImage setImage:filterItem.imageName];
        [itemWithImage setText:filterItem.displayName];
        [itemWithImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(i%2 ? @126:@41);
            make.left.equalTo(_contentView.mas_left).offset(i/2 ==0 ? 16 :i/2*66+16);
        }];
        lastView = itemWithImage;
        [self.sectionBtns addObject:lastView];
    }

    [vwImageHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.bottom.equalTo(_contentView);
        make.right.equalTo(lastView.mas_right);
        make.height.equalTo(@200);
    }];
}



- (void)initViewWithLableHolder {
    NSArray *items = [self filterItemWithType:MZLFilterItemTypeLabel];
    vwLableHolder = [self createViewWithParentView:_contentView];
    UIView *lastView;
    for (int i = 0; i < items.count; i ++) {
        MZLModelFilterItem *filterItem = items[i];
        MZLFilterItemWithLabel *itemWithLabel = [self createView:[MZLFilterItemWithLabel class] parent:vwLableHolder];
        itemWithLabel.delegate = self;
        itemWithLabel.tag = filterItem.identifier;
        [itemWithLabel setText:filterItem.displayName];
        
        [itemWithLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentView.mas_top).offset(62+(i%3*48));
            make.left.equalTo(vwSeparetorLine.mas_right).offset((i/3 == 0)?24 :i/3*66+24);
        }];
        lastView = itemWithLabel;
         [self.sectionBtns addObject:lastView];
       
    }

    
    [vwLableHolder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(_contentView);
        make.right.equalTo(lastView.mas_right);
        make.left.equalTo(vwSeparetorLine.mas_right);
    }];
    
}

- (void)initSeparatorLineInContentView {
    vwSeparetorLine = [self createViewWithParentView:_contentView];
    vwSeparetorLine.backgroundColor = colorWithHexString(@"#cccccc");
    [vwSeparetorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vwImageHolder.mas_right).offset(14);
        make.top.equalTo(_contentView).offset(46);
        make.width.equalTo(@0.5);
        make.bottom.equalTo(_contentView.mas_bottom);
    }];
}

@end
