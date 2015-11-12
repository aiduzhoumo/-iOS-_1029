//
//  MZLUserDetailResponse.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-21.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLServiceResponseObject.h"
#import "MZLModelUserInfoDetail.h"

@interface MZLUserDetailResponse : MZLServiceResponseObject

@property (nonatomic , strong) MZLModelUserInfoDetail *user;

@end
