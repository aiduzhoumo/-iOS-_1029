//
//  MZLPhotoItem.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-12.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    UNSELECTED,
    SELECTED
} MZLPhotoItemState;

@class ALAsset, MZLModelImage;

@interface MZLPhotoItem : NSObject

//@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, assign) MZLPhotoItemState state;
/** being set, this photo has been already uploaded */
@property (nonatomic, strong) MZLModelImage *uploadedImage;
/** image returned from TuSDK */
@property (nonatomic, strong) UIImage *tuSDKEditedImage;
/** image that has been handled (resized, apply filters) */
//@property (nonatomic, strong) UIImage *uploadImage;

@property (nonatomic, readonly) BOOL isSelected;
@property (nonatomic, readonly) NSDate *assetDate;
@property (nonatomic, readonly) NSString *assetUrl;

+ (instancetype)instanceWithAsset:(ALAsset *)asset;
+ (NSArray *)sortWithAssetDate:(NSArray *)array;

- (BOOL)isEqualToPhotoItem:(MZLPhotoItem *)anotherPhotoItem;

// 当照片被从系统相册删除时，ALAsset为nil
- (BOOL)isValid;
- (BOOL)isPhotoUploaded;
// 重置下载状态
- (void)resetUpload;

@end
