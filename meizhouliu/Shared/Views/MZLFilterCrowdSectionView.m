//
//  MZLFilterCrowdSectionScrollView.m
//  mzl_mobile_ios
//
//  Created by race on 14/11/19.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFilterCrowdSectionView.h"

#import "MZLFilterItemWithImage.h"

#import "MZLModelFilterType.h"
#import "MZLModelFilterItem.h"

#import <Masonry/Masonry.h>

@interface MZLFilterCrowdSectionView () {
    UIView *_contentView;
}

@end
@implementation MZLFilterCrowdSectionView

- (void)initInternal {
    [super initInternal];
    
    [self initSectionTitle:@"跟谁去" image:[UIImage imageNamed:@"Filter_People"]];
    _contentView = self.contentView;
    UIView *lastView;
    MZLFilterItemWithImage *itemView;
    
    for (int i = 0; i < self.filterOptions.items.count; i ++) {
        MZLModelFilterItem *filterItem = self.filterOptions.items[i];
        
        itemView = [self createView:[MZLFilterItemWithImage class] parent:_contentView];
        itemView.tag = filterItem.identifier;
        [itemView setText:filterItem.displayName];
        [itemView setImage:filterItem.imageName];
        itemView.delegate = self;
        
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@50);
            make.left.equalTo(lastView ? lastView.mas_right : @16);
            make.bottom.equalTo(_contentView.mas_bottom).offset(-16);
        }];
        lastView = itemView;
        [self.sectionBtns addObject:lastView];
    }
    
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_right);
    }];
    
}

@end
