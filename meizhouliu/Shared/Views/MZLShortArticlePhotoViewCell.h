//
//  MZLShortArticlePhotoViewCell.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-8.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MZL_SHORT_ARTICLE_PHOTO_VIEW_CELL_REUSE_IDENTIFIER @"MZLShortArticlePhotoViewCell"

@interface MZLShortArticlePhotoViewCell : UITableViewCell

- (instancetype)initWithPhotoItemSize:(CGSize)size;

- (void)updateCellOnIndexPath:(NSIndexPath *)indexPath photos:(NSArray *)photoItems isDisabled:(BOOL)isDisabled;
- (void)updateCellWithDisabledFlag:(BOOL)isDisabled;
- (void)updateCellStatus;

@end
