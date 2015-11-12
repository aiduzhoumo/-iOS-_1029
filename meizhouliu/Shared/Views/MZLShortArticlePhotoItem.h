//
//  MZLShortArticlePhotoItem.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-8.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZLPhotoItem;

@interface MZLShortArticlePhotoItem : UIView

- (void)updateWithPhoto:(MZLPhotoItem *)photoItem isDisabled:(BOOL)isDisabled;
- (void)updateWithDisabledFlag:(BOOL)isDisabled;
- (void)updateStatusDisplay;

- (void)showTuSDKEditedPhoto:(UIImage *)editedImage;
+ (instancetype)editInstanceWithPhoto:(MZLPhotoItem *)photoItem;

- (MZLPhotoItem *)associatedPhotoItem;

@end
