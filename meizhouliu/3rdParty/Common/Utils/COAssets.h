//
//  COAssets.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-8.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAsset;

@protocol COAssetsProtocol <NSObject>

@required
- (void)onAssetsLoaded:(NSArray *)assets;
- (void)onFailedToLoadAssets:(NSError *)error;

@end

@interface COAssets : NSObject

+ (void)co_loadAssetsFromSystem:(id<COAssetsProtocol>)delegate;
+ (NSArray *)co_thumbnailsFromAssets:(NSArray *)assets;
+ (UIImage *)co_thumbnailImageFromAsset:(ALAsset *)asset;
+ (UIImage *)co_fullScreenImageFromAsset:(ALAsset *)asset;

@end
