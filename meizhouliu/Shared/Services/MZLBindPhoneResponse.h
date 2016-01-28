//
//  MZLBindPhoneResponse.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/12/3.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import "MZLServiceResponseObject.h"
#import "MZLModelUser.h"

@interface MZLBindPhoneResponse : MZLServiceResponseObject

@property (nonatomic , strong) MZLModelUser *user;

@end
