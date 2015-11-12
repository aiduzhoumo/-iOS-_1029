//
//  MZLAuthorCoverCollectionViewCell.m
//  mzl_mobile_ios
//
//  Created by race on 14-9-19.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLAuthorCoverCollectionViewCell.h"
#import "UIImageView+MZLNetwork.h"
#import "MZLModelImage.h"

@implementation MZLAuthorCoverCollectionViewCell


- (void)updateOnFirstVisit:(MZLModelImage *)imageModel currentImageId:(NSInteger)currentImageId{
    self.isVisted = YES;
//    self.coverImage.frame = self.bounds;
    self.coverImage = imageModel;
    if (self.coverImage.identifier == currentImageId) {
        self.selectedImage.visible = YES;
        self.tag =  TAG_AUTHOR_COVER_SELECTED;
    }else{
        self.selectedImage.visible = NO;
    }
}

- (void)updateContentWithCoversImage:(NSString *)imageUrl {
    [self.vwCoverImage loadAuthorCoverFromURL:imageUrl];
}

@end
