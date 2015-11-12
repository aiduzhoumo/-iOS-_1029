//
//  COAssets.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-8.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "COAssets.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation COAssets

+ (void)co_loadAssetsFromSystem:(id<COAssetsProtocol>)delegate {
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    ALAssetsLibrary *library = [self co_assetsLibrary];
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        // Within the group enumeration block, filter if necessary
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [group enumerateAssetsUsingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            // The end of the enumeration is signaled by asset == nil.
                if (alAsset) {
                    [photos addObject:alAsset];
                }
            }];
            if (group && delegate) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [delegate onAssetsLoaded:[NSArray arrayWithArray:photos]];
                });
            }
        });
    } failureBlock: ^(NSError *error) {
        [delegate onFailedToLoadAssets:error];
    }];
}

+ (NSArray *)co_thumbnailsFromAssets:(NSArray *)assets {
    NSMutableArray *thumbnails = [[NSMutableArray alloc] init];
    for (ALAsset *asset in assets) {
        [thumbnails addObject:[self co_thumbnailImageFromAsset:asset]];
    }
    return [NSArray arrayWithArray:thumbnails];
}

+ (UIImage *)co_thumbnailImageFromAsset:(ALAsset *)asset {
    return [UIImage imageWithCGImage:[asset thumbnail]];
}

+ (UIImage *)co_fullScreenImageFromAsset:(ALAsset *)asset {
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    UIImage *result = [UIImage imageWithCGImage:[representation fullScreenImage]];
    return result;
}

#pragma mark - singleton for ALAssetsLibrary

/** Make this singleton so that it cannot be destroyed, or access to underlying photos will be denied */
+ (ALAssetsLibrary *)co_assetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

@end
