//
//  UIImageView+MZLNetwork.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+CONetwork.h"

#define MZL_DEFAULT_IMAGE_LOCATION_COVER @"Default_Loc_Cover"
#define MZL_DEFAULT_IMAGE_ARTICLE @"Default_Article"
#define MZL_DEFAULT_IMAGE_LOCATION_BIG @"Default_Loc_Big"

@interface UIImageView (MZLNetwork)

/** 按比例缩放 */
- (void)loadAuthorImageFromURL:(NSString *)URL;
- (void)loadAuthorCoverFromURL:(NSString *)URL;
- (void)loadBigLocationImageFromURL:(NSString *)URL;
- (void)loadSmallLocationImageFromURL:(NSString *)URL;
- (void)loadLocationImageFromURL:(NSString *)URL;
- (void)loadLocationCoverImageFromURL:(NSString *)URL;
- (void)loadUserImageFromURL:(NSString *)URL;
- (void)loadScaledImageFromURL:(NSString *)url callbackOnImageLoaded:(block_image_loaded)callbackOnImageLoaded;
- (void)loadArticleImageFromURL:(NSString *)URL callbackOnImageLoaded:(block_image_loaded)callbackOnImageLoaded;
- (void)load_540_366_ImageFromURL:(NSString *)url contextInfo:(NSDictionary *)contextInfo;


#pragma mark - utility

- (void)loadImageFromURL:(NSString *)URL placeholderImage:(UIImage *)placeholderImage mode:(NSString *)imageMode callbackOnImageLoaded:(block_image_loaded)callbackOnImageLoaded;
- (void)loadImageFromURL:(NSString *)URL placeholderImageName:(NSString *)placeholderImageName mode:(NSString *)imageMode callbackOnImageLoaded:(block_image_loaded)callbackOnImageLoaded;

- (void)loadImageFromURL:(NSString *)URL placeholderImageName:(NSString *)placeholderImageName mode:(NSString *)imageMode contextInfo:(NSDictionary *)contextInfo;
- (void)loadImageFromURL:(NSString *)URL placeholderImage:(UIImage *)placeholderImage mode:(NSString *)imageMode contextInfo:(NSDictionary *)contextInfo;


@end
