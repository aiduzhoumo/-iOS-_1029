//
//  MZLPhotoUploadingQueue.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-15.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MZL_NOTIFICATION_PHOTO_UPLOAD_SUCC @"MZL_NOTIFICATION_PHOTO_UPLOAD_SUCC"
#define MZL_NOTIFICATION_PHOTO_UPLOAD_FAILED @"MZL_NOTIFICATION_PHOTO_UPLOAD_FAILED"
#define MZL_NOTIFICATION_PHOTO_QUEUE_FINISH_UPLOADING @"MZL_NOTIFICATION_PHOTO_QUEUE_FINISH_UPLOADING"
#define MZL_PHOTO_UPLOAD_KEY_PHOTO @"MZL_PHOTO_UPLOAD_KEY_PHOTO"

@class MZLPhotoItem;

@interface MZLPhotoUploadingQueue : NSObject

- (void)uploadPhoto:(MZLPhotoItem *)photo;
- (void)cancelUpload:(MZLPhotoItem *)photo;

@end
