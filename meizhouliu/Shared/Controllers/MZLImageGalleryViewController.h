//
//  MZLImageGalleryViewController.h
//  mzl_mobile_ios
//
//  Created by race on 14-8-20.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "PTImageAlbumViewController.h"

#define MZL_IMAGE_GALLERY_SVC_FETCH_SIZE 50

@class MZLModelLocationBase;

@interface MZLImageGalleryViewController : PTImageAlbumViewController

//@property (nonatomic, strong) NSArray *locationAllPhotos;
@property (nonatomic, strong) MZLModelLocationBase *location;
@property (nonatomic, assign) NSInteger totalPhotoCount;

- (void)addPhotos:(NSArray *)photos;

@end
