//
//  MZLPhotoUploadingQueue.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-15.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLPhotoUploadingQueue.h"
#import "MZLPhotoItem.h"
#import "MZLPhotoUploadOperation.h"
#import <IBMessageCenter.h>

@interface MZLPhotoUploadingQueue () <MZLPhotoUploadProtocol> {
    NSMutableArray *_uploadingQueue;
    NSMutableArray *_pendingQueue;
}

@end

@implementation MZLPhotoUploadingQueue

- (instancetype)init {
    self = [super init];
    if (self) {
        _uploadingQueue = [NSMutableArray array];
        _pendingQueue = [NSMutableArray array];
    }
    return self;
}

- (void)uploadPhoto:(MZLPhotoItem *)photo {
    if ([photo isPhotoUploaded]) {
        return;
    }
    MZLPhotoUploadOperation *photoUpload = [[MZLPhotoUploadOperation alloc] init];
    photoUpload.photo = photo;
    if (_uploadingQueue.count > 0) {
        [_pendingQueue addObject:photoUpload];
    } else {
        [self _delayUploadPhoto:photoUpload];
    }
}

- (void)_delayUploadPhoto:(MZLPhotoUploadOperation *)operation {
    [_uploadingQueue addObject:operation];
    // 延迟3秒如果用户没有取消再开始上传
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([_uploadingQueue containsObject:operation]) {
            [self uploadPhotoWithOperation:operation];
        }
    });
}

- (void)_uploadPhoto:(MZLPhotoUploadOperation *)operation {
    [_uploadingQueue addObject:operation];
    [self uploadPhotoWithOperation:operation];
}

- (void)uploadNextPhoto {
    if (_pendingQueue.count == 0) {
        [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_PHOTO_QUEUE_FINISH_UPLOADING];
        return;
    } else {
        MZLPhotoUploadOperation *operation = _pendingQueue[0];
        [_pendingQueue removeObjectAtIndex:0];
        [self _uploadPhoto:operation];
    }
}

- (void)uploadPhotoWithOperation:(MZLPhotoUploadOperation *)uploadOperation {
    [uploadOperation startUploadingPhotoWithDelegate:self];
}

- (void)cancelUpload:(MZLPhotoItem *)photo {
    [self cancelUploadInPendingQueue:photo];
    [self cancelUploadInUploadQueue:photo];
}

- (void)cancelUploadInUploadQueue:(MZLPhotoItem *)photo {
    MZLPhotoUploadOperation *target = [_uploadingQueue find:^BOOL(MZLPhotoUploadOperation *oper) {
        return [oper isAssociatedWithPhoto:photo];
    }];
    if (target) {
        [target cancel];
        [_uploadingQueue removeObject:target];
        [self uploadNextPhoto];
    }
}

- (void)cancelUploadInPendingQueue:(MZLPhotoItem *)photo {
    MZLPhotoUploadOperation *target = [_pendingQueue find:^BOOL(MZLPhotoUploadOperation *oper) {
        return [oper isAssociatedWithPhoto:photo];
    }];
    if (target) {
        [_pendingQueue removeObject:target];
    }
}

#pragma mark - MZLPhotoUploadProtocol

- (void)onPhotoUploadSucceed:(MZLPhotoUploadOperation *)operation {
    [_uploadingQueue removeObject:operation];
    [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_PHOTO_UPLOAD_SUCC withUserInfo:@{MZL_PHOTO_UPLOAD_KEY_PHOTO : operation.photo}];
    [self uploadNextPhoto];
}

- (void)onPhotoUploadFailed:(NSError *)error {
    // 只要出错，移除全部(上传队列目前同时最多只有一个上传操作)
    [_uploadingQueue removeAllObjects];
    [_pendingQueue removeAllObjects];
    [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_PHOTO_UPLOAD_FAILED];
}

@end
