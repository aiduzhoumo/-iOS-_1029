//
//  MZLModelLoginUserInfo.h
//  mzl_mobile_ios
//
//  Created by alfred on 14-7-30.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLServiceResponseObject.h"
@class MZLModelUser,MZLModelAccessToken,MZLMessagesResponse;

@interface MZLRegLoginResponse : MZLServiceResponseObject

@property (nonatomic , strong) MZLModelUser *user;
@property (nonatomic , strong) MZLModelAccessToken *accessToken;
@property(nonatomic, readonly) NSString *headerImageUrl;

@end
