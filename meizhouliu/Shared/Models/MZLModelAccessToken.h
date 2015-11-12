//
//  MZLModelAccessToken.h
//  mzl_mobile_ios
//
//  Created by alfred on 14-7-31.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"

@interface MZLModelAccessToken : NSObject
@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *refreshToken;
@property(nonatomic, copy) NSString *expiresAt;
@end
