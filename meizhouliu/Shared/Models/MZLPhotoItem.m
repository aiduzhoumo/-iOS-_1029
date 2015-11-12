//
//  MZLPhotoItem.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-12.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLPhotoItem.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation MZLPhotoItem

- (BOOL)isSelected {
    return self.state == SELECTED;
}

- (NSDate *)assetDate {
    return [self.asset valueForProperty:ALAssetPropertyDate];
}

- (NSString *)assetUrl {
    NSURL *url = [self.asset valueForProperty:ALAssetPropertyAssetURL];
    return [url absoluteString];
}

+ (instancetype)instanceWithAsset:(ALAsset *)asset {
    MZLPhotoItem *result = [[MZLPhotoItem alloc] init];
    result.asset = asset;
    result.state = UNSELECTED;
    return result;
}

+ (NSArray *)sortWithAssetDate:(NSArray *)array {
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"assetDate" ascending:NO];
    NSArray *result = [array sortedArrayUsingDescriptors:@[sort]];
    return result;
}

- (BOOL)isEqualToPhotoItem:(MZLPhotoItem *)anotherPhotoItem {
    return [[self assetUrl] isEqualToString:[anotherPhotoItem assetUrl]];
}

- (BOOL)isValid {
    return [self assetUrl] != nil;
}

- (BOOL)isPhotoUploaded {
    return self.uploadedImage != nil;
}

- (void)resetUpload {
    self.uploadedImage = nil;
}

@end
