//
//  MZLPhotoUploadOperation.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-15.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLPhotoUploadOperation.h"
#import "MZLPhotoItem.h"
#import "MZLServices.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "COAssets.h"
#import "UIImage+COAdditions.h"
#import "MZLServices.h"
#import "MZLImageUploadResponse.h"

#define MAX_ERROR_RETRY_TIMES 1

@interface MZLPhotoUploadOperation () {
    __weak NSOperation * _internal;
    __weak id<MZLPhotoUploadProtocol> _delegate;
    NSInteger _retryTimes;
    BOOL _cancelled;
}

@end

@implementation MZLPhotoUploadOperation

- (BOOL)isAssociatedWithPhoto:(MZLPhotoItem *)photo {
    return [self.photo isEqualToPhotoItem:photo];
}

- (void)startUploadingPhotoWithDelegate:(id<MZLPhotoUploadProtocol>)delegate {
    if (self.photo.asset) {
        _delegate = delegate;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *srcImage = self.photo.tuSDKEditedImage;
            if (! srcImage) { // 照片没被编辑过，取原始图片
                srcImage = [COAssets co_fullScreenImageFromAsset:self.photo.asset];
            }
            // scale
            UIImage *scaledImage = [srcImage co_resizeWithMaxWidth:CO_IPHONE6_PLUS_SCREEN_WIDTH maxHeight:CO_IPHONE6_PLUS_SCREEN_HEIGHT widthHasPriority:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self uploadPhoto:scaledImage];
            });
        });
    }
}

- (void)uploadPhoto:(UIImage *)image {
    if (_cancelled) {
        return;
    }
    _internal = [MZLServices uploadPhoto:image succBlock:^(NSArray *models) {
        MZLImageUploadResponse *response = models[0];
        [self onUploadSucc:response];
    } errorBlock:^(NSError *error) {
        [self onUploadFailed:error image:image];
    }];
}

- (void)onUploadSucc:(MZLImageUploadResponse *)response {
    self.photo.uploadedImage = response.image;
    if (_delegate && [_delegate respondsToSelector:@selector(onPhotoUploadSucceed:)]) {
        [_delegate onPhotoUploadSucceed:self];
    }
}

- (void)onUploadFailed:(NSError *)error image:(UIImage *)image {
    if (_retryTimes ++ < MAX_ERROR_RETRY_TIMES) {
        [self uploadPhoto:image];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(onPhotoUploadFailed:)]) {
        [_delegate onPhotoUploadFailed:error];
    }
}

- (void)cancel {
    _cancelled = YES;
    if (_internal) {
        [_internal cancel];
    }
}

@end
