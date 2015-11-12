//
//  MZLRegister3rdPartySvcParam.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-13.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLRegisterBaseSvcParam.h"

@interface MZLRegister3rdPartySvcParam : MZLRegisterBaseSvcParam

@property (nonatomic , copy) NSString *openID;
@property (nonatomic , copy) NSString *token;
@property (nonatomic , copy) NSString *expiresIn;
@property (nonatomic , copy) NSString *refreshToken;
@property (nonatomic , copy) NSString *photo;

@end
