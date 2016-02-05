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
#import "MZLImageUpLoadToUPaiYunResponse.h"

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
            NSString *imageName = self.photo.imageName;
            MZLLog(@"imageName ************   %@",imageName);
            if (! srcImage) { // 照片没被编辑过，取原始图片
                srcImage = [COAssets co_fullScreenImageFromAsset:self.photo.asset];
            }
            // scale
            UIImage *scaledImage = [srcImage co_resizeWithMaxWidth:CO_IPHONE6_PLUS_SCREEN_WIDTH maxHeight:CO_IPHONE6_PLUS_SCREEN_HEIGHT widthHasPriority:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self uploadPhoto:scaledImage];
                [self uploadPhoto:scaledImage imageName:imageName];
                
            });
        });
    }
}

- (void)uploadPhoto:(UIImage *)image imageName:(NSString *)imageName {
    if (_cancelled) {
        return;
    }                                                     
    [MZLServices toGetupyun_configAndImageID:image iamgeName:imageName succBlock:^(NSArray *models) {
        MZLLog(@"上传成功 *** models ===== %@",models);
        MZLImageUpLoadToUPaiYunResponse *response = models[0];
        [self onUploadSucc:response image:image imageName:imageName];
    } errorBlock:^(NSError *error) {
        MZLLog(@"上传失败 *** error ==== %@",error);
        //重新上传
        [self uploadPhoto:image imageName:imageName];
    }];
}

- (void)onUploadSucc:(MZLImageUpLoadToUPaiYunResponse *)response image:(UIImage *)image imageName:(NSString *)imageName{
    self.photo.uploadUpaiYunImage = response.image;
    
    _internal = [MZLServices uploadPhotoToUPaiYun:image imageName:imageName imageUpToUPaiYunResponse:response succBlock:^{
        if (_delegate && [_delegate respondsToSelector:@selector(onPhotoUploadSucceed:)]) {
            [_delegate onPhotoUploadSucceed:self];
        }
    } errorBlock:^(NSError *error) {
        [self onUploadFailed:error image:image imageName:imageName];
    }];
    
}

- (void)onUploadFailed:(NSError *)error image:(UIImage *)image imageName:(NSString *)imageName {
    if (_retryTimes ++ < MAX_ERROR_RETRY_TIMES) {
        //        [self uploadPhoto:image];
        [self uploadPhoto:image imageName:imageName];
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
