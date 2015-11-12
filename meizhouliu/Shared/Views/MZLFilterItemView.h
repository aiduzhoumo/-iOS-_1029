//
//  MZLFilterItemView.h
//  Test
//
//  Created by Whitman on 14-9-5.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLFilterView.h"

@protocol MZLFilterItemViewDelegate <NSObject>

- (void)onFilterOptionStateModified;

@end

@interface MZLFilterItemView : MZLFilterView

@property(nonatomic, weak) id delegate;

- (BOOL)isSelected;
- (void)setSelected:(BOOL)flag;
- (void)setText:(NSString *)text;
- (NSString *)formattedText:(NSString *)text;

@end
