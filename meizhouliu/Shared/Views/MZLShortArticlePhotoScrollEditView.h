//
//  MZLShortArticlePhotoScrollEditView.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-13.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZLPhotoItem;

@interface MZLShortArticlePhotoScrollEditView : UIView

@property (nonatomic, assign) CGSize photoItemSize;

- (void)handlePhotoItem:(MZLPhotoItem *)photoItem;
- (void)reloadWithPhotoItems:(NSArray *)photoItems;

@end
