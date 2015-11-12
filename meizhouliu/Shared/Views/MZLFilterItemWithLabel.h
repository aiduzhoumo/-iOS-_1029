//
//  MZLFilterItemWithLabel.h
//  mzl_mobile_ios
//
//  Created by race on 14/11/19.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFilterView.h"

@interface MZLFilterItemWithLabel : MZLFilterView {
    @protected
    BOOL _isSelected;
}

@property(nonatomic, weak) id delegate;

#pragma mark - public
//- (void)initInternal;
- (BOOL)isSelected;
- (void)setSelected:(BOOL)flag;
- (void)setText:(NSString *)text;

#pragma mark - protected
- (void)initUI;

@end

@protocol MZLFilterItemDelegate <NSObject>

- (void)onFilterOptionStateModified;

@end
