//
//  UIImageView+MZLNetwork.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIImageView+MZLNetwork.h"
#import "UIImageView+CONetwork.h"
#import "NSString+COMd5.h"
#import "NSString+MZLImageURL.h"

@implementation UIImageView (MZLNetwork)

#pragma mark - load image with only loaded block

- (void)loadAuthorImageFromURL:(NSString *)URL {
    [self loadImageFromURL:URL placeholderImageName:@"Default_Author" mode:MZL_IMAGE_MODE_180_180 callbackOnImageLoaded:nil];
}

- (void)loadAuthorCoverFromURL:(NSString *)URL {
    [self loadImageFromURL:URL placeholderImageName:@"Default_Author_Cover" mode:MZL_IMAGE_MODE_640_1008 callbackOnImageLoaded:nil];
}

- (void)loadArticleImageFromURL:(NSString *)URL callbackOnImageLoaded:(block_image_loaded)callbackOnImageLoaded {
    [self loadImageFromURL:URL placeholderImageName:MZL_DEFAULT_IMAGE_ARTICLE mode:MZL_IMAGE_MODE_580_386 callbackOnImageLoaded:callbackOnImageLoaded];
}

- (void)loadBigLocationImageFromURL:(NSString *)URL {
    [self loadImageFromURL:URL placeholderImageName:MZL_DEFAULT_IMAGE_LOCATION_BIG mode:MZL_IMAGE_MODE_540_366 callbackOnImageLoaded:nil];
}

- (void)loadSmallLocationImageFromURL:(NSString *)URL {
    [self loadImageFromURL:URL placeholderImageName:@"Default_Loc_Small" mode:MZL_IMAGE_MODE_210_210 callbackOnImageLoaded:nil];
}

- (void)loadLocationImageFromURL:(NSString *)URL {
    [self loadImageFromURL:URL placeholderImageName:MZL_DEFAULT_IMAGE_LOCATION_BIG mode:MZL_IMAGE_MODE_640_400 callbackOnImageLoaded:nil];
}

- (void)loadLocationCoverImageFromURL:(NSString *)URL {
    [self loadImageFromURL:URL placeholderImageName:MZL_DEFAULT_IMAGE_LOCATION_COVER mode:MZL_IMAGE_MODE_640_600 callbackOnImageLoaded:nil];
}

- (void)loadUserImageFromURL:(NSString *)URL {
    [self loadImageFromURL:URL placeholderImageName:@"DefaultUserHeader" mode:MZL_IMAGE_MODE_210_210 callbackOnImageLoaded:nil];
}

- (void)loadScaledImageFromURL:(NSString *)URL callbackOnImageLoaded:(block_image_loaded)callbackOnImageLoaded {
    [self loadImageFromURL:URL placeholderImageName:MZL_DEFAULT_IMAGE_LOCATION_BIG mode:MZL_IMAGE_MODE_SCALED callbackOnImageLoaded:callbackOnImageLoaded];
}

#pragma mark - load images with full features

- (void)load_540_366_ImageFromURL:(NSString *)url contextInfo:(NSDictionary *)contextInfo {
    [self loadImageFromURL:url placeholderImageName:MZL_DEFAULT_IMAGE_LOCATION_BIG mode:MZL_IMAGE_MODE_540_366 contextInfo:contextInfo];
}

#pragma mark - utility with only image loaded block

- (void)loadImageFromURL:(NSString *)URL placeholderImageName:(NSString *)placeholderImageName {
    return [self loadImageFromURL:URL placeholderImageName:placeholderImageName mode:nil callbackOnImageLoaded:nil];
}

- (void)loadImageFromURL:(NSString *)URL placeholderImageName:(NSString *)placeholderImageName callbackOnImageLoaded:(block_image_loaded)callbackOnImageLoaded {
    return [self loadImageFromURL:URL placeholderImageName:placeholderImageName mode:nil callbackOnImageLoaded:callbackOnImageLoaded];
}

- (void)loadImageFromURL:(NSString *)URL placeholderImageName:(NSString *)placeholderImageName mode:(NSString *)imageMode callbackOnImageLoaded:(block_image_loaded)callbackOnImageLoaded {
    UIImage *placeHolderImage = nil;
    if (placeholderImageName) {
        placeHolderImage = [UIImage imageNamed:placeholderImageName];
    }
    [self loadImageFromURL:URL placeholderImage:placeHolderImage mode:imageMode callbackOnImageLoaded:callbackOnImageLoaded];
}

- (void)loadImageFromURL:(NSString *)URL placeholderImage:(UIImage *)placeholderImage mode:(NSString *)imageMode callbackOnImageLoaded:(block_image_loaded)callbackOnImageLoaded {
    NSDictionary *contextInfo;
    if (callbackOnImageLoaded) {
        contextInfo = @{KEY_CO_IMAGE_LOADED_BLOCK : callbackOnImageLoaded};
    }
    [self loadImageFromURL:URL placeholderImage:placeholderImage mode:imageMode contextInfo:contextInfo];
}

#pragma mark - utility with full features

- (void)loadImageFromURL:(NSString *)URL placeholderImageName:(NSString *)placeholderImageName mode:(NSString *)imageMode contextInfo:(NSDictionary *)contextInfo {
    UIImage *placeHolderImage = nil;
    if (placeholderImageName) {
        placeHolderImage = [UIImage imageNamed:placeholderImageName];
    }
    [self loadImageFromURL:URL placeholderImage:placeHolderImage mode:imageMode contextInfo:contextInfo];
}

- (void)loadImageFromURL:(NSString *)URL placeholderImage:(UIImage *)placeholderImage mode:(NSString *)imageMode contextInfo:(NSDictionary *)contextInfo {
    if (isEmptyString(URL)) {
        self.image = placeholderImage;
        return;
    }
    NSString *imageURL = [URL imageUrlWithMode:imageMode];
    [self loadImageFromURL:[NSURL URLWithString:imageURL] placeholderImage:placeholderImage cachingKey:[imageURL MD5Hash] contextInfo:contextInfo];
}

@end
