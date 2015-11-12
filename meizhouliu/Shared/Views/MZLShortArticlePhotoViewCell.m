//
//  MZLShortArticlePhotoViewCell.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-8.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLShortArticlePhotoViewCell.h"
#import "MZLShortArticlePhotoItem.h"
#import "UIView+MZLAdditions.h"
#import "MZLShortArticleContentVC.h"

#define MZL_SHORT_ARTICLE_PHOTO_VIEW_CELL_H_MARGIN MZL_SA_PHOTO_CELL_H_MARGIN
#define MZL_SHORT_ARTICLE_PHOTO_VIEW_CELL_V_MARGIN MZL_SHORT_ARTICLE_PHOTO_VIEW_CELL_H_MARGIN
#define PHOTO_ITEMS_PER_ROW 3

@interface MZLShortArticlePhotoViewCell () {
    __weak UIView *_topView;
    NSMutableArray *_photoItemViews;
}

@property(nonatomic, assign) CGSize photoItemSize;

@end

@implementation MZLShortArticlePhotoViewCell

- (instancetype)initWithPhotoItemSize:(CGSize)size {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MZL_SHORT_ARTICLE_PHOTO_VIEW_CELL_REUSE_IDENTIFIER];
    if (self) {
        _photoItemSize = size;
        [self internalInit];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - init

- (void)internalInit {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *topView = [self.contentView createSubView];
    _topView = topView;
//    topView.backgroundColor = [UIColor redColor];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.right.mas_equalTo(topView.superview);
        make.height.mas_equalTo(self.photoItemSize.height);
    }];
    _photoItemViews = [NSMutableArray array];
    for (int i = 0; i < PHOTO_ITEMS_PER_ROW; i++) {
        MZLShortArticlePhotoItem *photoItem = [[MZLShortArticlePhotoItem alloc] init];
        [topView addSubview:photoItem];
        [_photoItemViews addObject:photoItem];
        [photoItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(photoItem.superview);
            make.width.mas_equalTo(self.photoItemSize.width);
            if (i == 0) {
                make.left.mas_equalTo(photoItem.superview);
            } else {
                MZLShortArticlePhotoItem *preItem = _photoItemViews[i - 1];
                make.left.mas_equalTo(preItem.mas_right).offset(MZL_SHORT_ARTICLE_PHOTO_VIEW_CELL_H_MARGIN);
            }
        }];
    }
    
    UIView *sep = [self.contentView createSubView];
//    sep.backgroundColor = [UIColor greenColor];
    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.right.mas_equalTo(sep.superview);
        make.height.mas_equalTo(MZL_SHORT_ARTICLE_PHOTO_VIEW_CELL_V_MARGIN);
    }];
}

#pragma mark - photo related

- (void)updateCellOnIndexPath:(NSIndexPath *)indexPath photos:(NSArray *)photoItems isDisabled:(BOOL)isDisabled {
    for (MZLShortArticlePhotoItem *photoItemView in _photoItemViews) {
        photoItemView.hidden = YES;
    }
    NSMutableArray *tempPhotos = [NSMutableArray arrayWithArray:photoItems];
    [tempPhotos insertObject:@"DummyObject" atIndex:0];
    NSInteger startIndex = indexPath.row * PHOTO_ITEMS_PER_ROW;
    NSInteger upperbound = startIndex + PHOTO_ITEMS_PER_ROW;
    upperbound = MIN(upperbound, tempPhotos.count);
    for (NSInteger i = startIndex; i < upperbound; i ++) {
        NSInteger photoItemViewIndex = i % 3;
        MZLShortArticlePhotoItem *photoItemView = _photoItemViews[photoItemViewIndex];
        photoItemView.hidden = NO;
        if (i == 0) {
            [photoItemView updateWithPhoto:nil isDisabled:isDisabled];
        } else {
            [photoItemView updateWithPhoto:tempPhotos[i] isDisabled:isDisabled];
        }
    }
    
}

- (void)updateCellWithDisabledFlag:(BOOL)isDisabled {
    for (MZLShortArticlePhotoItem *photoItemView in _photoItemViews) {
        [photoItemView updateWithDisabledFlag:isDisabled];
    }
}

- (void)updateCellStatus {
    for (MZLShortArticlePhotoItem *photoItemView in _photoItemViews) {
        [photoItemView updateStatusDisplay];
    }
}

@end
