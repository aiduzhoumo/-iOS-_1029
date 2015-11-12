//
//  MZLAuthorCoverCollectionViewCell.h
//  mzl_mobile_ios
//
//  Created by race on 14-9-19.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAG_AUTHOR_COVER_SELECTED 100

@class MZLModelImage;

@interface MZLAuthorCoverCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *vwCoverImage;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;

@property (assign, nonatomic) BOOL isVisted;
@property (assign, nonatomic) MZLModelImage *coverImage;

- (void)updateOnFirstVisit:(MZLModelImage *)imageModel currentImageId:(NSInteger)currentImageId;
- (void)updateContentWithCoversImage:(NSString *)imageUrl;
@end
