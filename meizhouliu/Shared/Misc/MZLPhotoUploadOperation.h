//
//  MZLPhotoUploadOperation.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-15.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MZLPhotoItem, MZLPhotoUploadOperation;

@protocol MZLPhotoUploadProtocol <NSObject>

@optional
- (void)onPhotoUploadSucceed:(MZLPhotoUploadOperation *)operation;
- (void)onPhotoUploadFailed:(NSError *)error;

@end

/** Not a real operation class, just a wrapper for its internal operation */
@interface MZLPhotoUploadOperation : NSOperation

@property (nonatomic, strong) MZLPhotoItem *photo;

- (BOOL)isAssociatedWithPhoto:(MZLPhotoItem *)photo;
- (void)startUploadingPhotoWithDelegate:(id<MZLPhotoUploadProtocol>)delegate;

@end
