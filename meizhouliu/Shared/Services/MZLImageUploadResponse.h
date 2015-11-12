//
//  MZLImageUploadResponse.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-17.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLServiceResponseObject.h"
#import "MZLModelImage.h"

@interface MZLImageUploadResponse : MZLServiceResponseObject

@property (nonatomic, strong) MZLModelImage *image;

@end
