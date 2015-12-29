//
//  MZLAppUser.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-12.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZLModelAccessToken.h"
#import "MZLModelUser.h"

@interface MZLAppUser : NSObject<NSCoding>

/** 跟后台绑定的token */
@property (nonatomic, strong) MZLModelAccessToken *token;
/** 跟后台绑定的user */
@property (nonatomic, strong) MZLModelUser *user;

@property (nonatomic, copy) NSString *duzhoumoToken;

@property (nonatomic, copy) NSString *tokenFrom3rdParty;
@property (nonatomic, copy) NSString *openIdFrom3rdParty;
@property (nonatomic, copy) NSString *imageUrlFrom3rdParty;
@property (nonatomic, copy) NSString *nickNameFrom3rdParty;
@property (nonatomic, copy) NSDate *expirationDateFrom3rdParty;
@property (nonatomic, readonly) NSString *expirationFrom3rdParty;

@property (nonatomic, assign) BOOL isBindPhone;

@property (nonatomic, readonly) BOOL isLogined;
@property (nonatomic, assign) MZLLoginType loginType;

/** 是否使用第三方登录 */
- (BOOL)isLoginFrom3rdParty;

- (void)setUser:(MZLModelUser *)user token:(MZLModelAccessToken *)token;

+ (MZLAppUser *)loadUserFromPreference;
+ (void)removeUserFromPreference;
- (void)saveInPreference;

@end
