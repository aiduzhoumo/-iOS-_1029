//
//  MZLShortArticlePhotoScrollEditView.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-13.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLShortArticlePhotoScrollEditView.h"
#import "MZLPhotoItem.h"
#import "MZLShortArticlePhotoItem.h"
#import "UIView+MZLAdditions.h"
#import "MZLShortArticleContentVC.h"

#define ITEMS_PER_ROW 3
#define ANIMATION_DURATION 0.3

@interface MZLShortArticlePhotoScrollEditView () {
    NSMutableArray *_photoItemViews;
}

@end

@implementation MZLShortArticlePhotoScrollEditView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initInternal];
    }
    return self;
}

- (void)initInternal {
    _photoItemViews = co_emptyMutableArray();
}

- (CGFloat)rowHeight {
    return self.photoItemSize.height + MZL_SA_PHOTO_CELL_V_MARGIN;
}

- (CGFloat)cellWidth {
    return self.photoItemSize.width + MZL_SA_PHOTO_CELL_H_MARGIN;
}

- (void)addPhotoItem:(MZLPhotoItem *)photoItem {
    [self addPhotoItem:photoItem animated:YES];
}

- (void)addPhotoItem:(MZLPhotoItem *)photoItem animated:(BOOL)flag {
    MZLShortArticlePhotoItem *itemView = [MZLShortArticlePhotoItem editInstanceWithPhoto:photoItem];
    [_photoItemViews addObject:itemView];
    NSInteger rowCount = _photoItemViews.count / ITEMS_PER_ROW;
    if (_photoItemViews.count % ITEMS_PER_ROW > 0) {
        rowCount ++;
        if (_photoItemViews.count % ITEMS_PER_ROW == 1) {
            // 增加一新行
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(rowCount * [self rowHeight]);
            }];
        }
    }
    CGFloat yPos = (rowCount - 1) * [self rowHeight];
    CGFloat xPos;
    if (_photoItemViews.count % ITEMS_PER_ROW == 0) {
        xPos = (ITEMS_PER_ROW - 1) * [self cellWidth];
    } else {
        xPos = (_photoItemViews.count % ITEMS_PER_ROW - 1) * [self cellWidth];
    }
    itemView.frame = CGRectMake(xPos, yPos, self.photoItemSize.width, self.photoItemSize.height);
    [self addSubview:itemView];
    if (flag) {
        itemView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            itemView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)deletePhotoItem:(MZLPhotoItem *)photoItem {
    NSInteger index = -1;
    for (int i = 0; i < _photoItemViews.count; i ++) {
        MZLShortArticlePhotoItem *photoItemView = _photoItemViews[i];
        if ([[photoItemView associatedPhotoItem] isEqualToPhotoItem:photoItem]) {
            index = i;
            break;
        }
    }
    if (index == -1) {
        return;
    }
    MZLShortArticlePhotoItem *photoItemView = _photoItemViews[index];
    [_photoItemViews removeObjectAtIndex:index];
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        photoItemView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [photoItemView removeFromSuperview];
        [self adjustPhotoPositionFromIndex:index];
    }];
}

- (void)deletePhotoItem:(MZLPhotoItem *)photoItem animated:(BOOL)flag {
    NSInteger index = -1;
    for (int i = 0; i < _photoItemViews.count; i ++) {
        MZLShortArticlePhotoItem *photoItemView = _photoItemViews[i];
        if ([[photoItemView associatedPhotoItem] isEqualToPhotoItem:photoItem]) {
            index = i;
            break;
        }
    }
    if (index == -1) {
        return;
    }
    MZLShortArticlePhotoItem *photoItemView = _photoItemViews[index];
    [_photoItemViews removeObjectAtIndex:index];
    if (flag) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            photoItemView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished) {
            [photoItemView removeFromSuperview];
            [self adjustPhotoPositionFromIndex:index];
        }];
    } else {
        [photoItemView removeFromSuperview];
        [self adjustPhotoPositionFromIndex:index];
    }
}

- (void)adjustPhotoPositionFromIndex:(NSInteger)index {
    NSInteger rowCount = _photoItemViews.count / ITEMS_PER_ROW;
    if (_photoItemViews.count % ITEMS_PER_ROW > 0) {
        rowCount ++;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(rowCount * [self rowHeight]);
        }];
    }
    [UIView animateWithDuration:0.5 animations:^{
        for (NSInteger i = index; i < _photoItemViews.count; i ++) {
            MZLShortArticlePhotoItem *photoItemView = _photoItemViews[i];
            CGFloat xPos = 0;
            if (i % ITEMS_PER_ROW > 0) {
                xPos = (i % ITEMS_PER_ROW) * [self cellWidth];
            }
            CGFloat yPos = (i / ITEMS_PER_ROW) * [self rowHeight];
            photoItemView.frame = CGRectMake(xPos, yPos, photoItemView.width, photoItemView.height);
        }
    }];
}

#pragma mark - public

- (void)handlePhotoItem:(MZLPhotoItem *)photoItem {
    if (photoItem.state == SELECTED) {
        [self addPhotoItem:photoItem];
    } else {
        [self deletePhotoItem:photoItem];
    }
}

- (void)reloadWithPhotoItems:(NSArray *)photoItems {
    for (MZLShortArticlePhotoItem *photoItemView in _photoItemViews) {
        [photoItemView removeFromSuperview];
    }
    [_photoItemViews removeAllObjects];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    for (MZLPhotoItem *photoItem in photoItems) {
        [self addPhotoItem:photoItem animated:NO];
    }
}

@end
