//
//  MZLModelUserInfoDetail.h
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-15.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelUser.h"

typedef NS_ENUM(NSInteger, MZLModelUserSex) {
    MZLModelUserSexUnknown = 0,
    MZLModelUserSexMale   = 1,
    MZLModelUserSexFemale  = 2
};

@interface MZLModelUserInfoDetail : MZLModelUser

@property (nonatomic, assign) MZLModelUserSex sex;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, strong) MZLModelImage *coverImage;
@end
