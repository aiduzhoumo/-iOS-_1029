//
//  MZLNoticeResponse.h
//  mzl_mobile_ios
//
//  Created by race on 14-9-4.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLServiceResponseObject.h"
#import "MZLModelNotice.h"

@interface MZLNoticeResponse : MZLServiceResponseObject

@property (nonatomic, strong) MZLModelNotice *notice;

@end
