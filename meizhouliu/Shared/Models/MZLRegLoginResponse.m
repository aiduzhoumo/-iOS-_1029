//
//  MZLModelLoginUserInfo.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-7-30.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLRegLoginResponse.h"
#import "MZLModelImage.h"
#import "MZLModelUser.h"

@implementation MZLRegLoginResponse

- (NSString *)headerImageUrl {
    
    return self.user.headerImage.fileUrl;
}

@end
