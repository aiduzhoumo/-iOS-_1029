//
//  MZLAppUser.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-12.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLAppUser.h"
#import "MZLModelImage.h"


@implementation MZLAppUser

- (BOOL)isLogined {
    
    NSLog(@"self.user.bind = == == %@",self.user.bind);
    
    if (![self.user.bind isEqualToString:@"true"]) {
        return NO;
    }
    return (self.user && self.token);
}


//&& (self.user.phone.length != 0)
- (NSString *)expirationFrom3rdParty {
    if (self.expirationDateFrom3rdParty) {
        NSString *expiresIn = [NSString stringWithFormat:@"%f", [self.expirationDateFrom3rdParty timeIntervalSinceNow]];
        NSRange range = [expiresIn rangeOfString:@"."];
        return [expiresIn substringToIndex:range.location];
    }
    return nil;
}

- (BOOL)isLoginFrom3rdParty {
    return self.loginType == MZLLoginTypeQQ || self.loginType == MZLLoginTypeSinaWeibo || self.loginType == MZLLoginTypeWeiXin;
}

#pragma mark - NSCoding protocol

#define KEY_USER_ID @"USER_ID"
#define KEY_USER_NICKNAME @"KEY_USER_NICKNAME"
//#define KEY_USER_IMAGE_URL @"KEY_USER_IMAGE_URL"
#define KEY_USER_LEVEL @"KEY_USER_LEVEL"
#define KEY_USER_PHONE @"KEY_USER_PHONE"
#define KEY_USER_BIND @"KEY_USER_BIND"

#define KEY_USER_TOKEN @"KEY_USER_TOKEN"
#define KEY_USER_REFRESH_TOKEN @"KEY_USER_REFRESH_TOKEN"
#define KEY_USER_EXPIRATION @"KEY_USER_EXPIRATION"

#define KEY_USER_LOGIN_TYPE @"KEY_USER_LOGIN_TYPE"

#define KEY_USER_3RD_PARTY_OPENID @"KEY_USER_3RD_PARTY_OPENID"
//#define KEY_USER_3RD_PARTY_TOKEN @"KEY_USER_3RD_PARTY_TOKEN"
//#define KEY_USER_3RD_PARTY_IMAGE_URL @"KEY_USER_3RD_PARTY_IMAGE_URL"
//#define KEY_USER_3RD_PARTY_NICK_NAME @"KEY_USER_3RD_PARTY_NICK_NAME"
//#define KEY_USER_3RD_PARTY_EXPIRATION @"KEY_USER_3RD_PARTY_EXPIRATION"

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.openIdFrom3rdParty = [aDecoder decodeObjectForKey:KEY_USER_3RD_PARTY_OPENID];
//        self.tokenFrom3rdParty = [aDecoder decodeObjectForKey:KEY_USER_3RD_PARTY_TOKEN];
//        self.imageUrlFrom3rdParty = [aDecoder decodeObjectForKey:KEY_USER_3RD_PARTY_IMAGE_URL];
//        self.nickNameFrom3rdParty = [aDecoder decodeObjectForKey:KEY_USER_3RD_PARTY_NICK_NAME];
//        self.expirationDateFrom3rdParty = [aDecoder decodeObjectForKey:KEY_USER_3RD_PARTY_EXPIRATION];
        
        self.loginType = [[aDecoder decodeObjectForKey:KEY_USER_LOGIN_TYPE] integerValue];
        
//        self.isBindPhone = [[aDecoder decodeObjectForKey:KEY_USER_BIND_PHONE] integerValue];
        
        MZLModelAccessToken *token = [[MZLModelAccessToken alloc] init];
        token.token = [aDecoder decodeObjectForKey:KEY_USER_TOKEN];
        token.refreshToken = [aDecoder decodeObjectForKey:KEY_USER_REFRESH_TOKEN];
        token.expiresAt = [aDecoder decodeObjectForKey:KEY_USER_EXPIRATION];
        
        MZLModelUser *user = [[MZLModelUser alloc] init];
        user.identifier = [[aDecoder decodeObjectForKey:KEY_USER_ID] integerValue];
        user.nickName = [aDecoder decodeObjectForKey:KEY_USER_NICKNAME];
        user.phone = [aDecoder decodeObjectForKey:KEY_USER_PHONE];
        user.bind = [aDecoder decodeObjectForKey:KEY_USER_BIND];
        user.level = [[aDecoder decodeObjectForKey:KEY_USER_LEVEL] integerValue];
               
//        user
//        self.user.headerImage = [[MZLModelImage alloc] init];
//        self.user.headerImage.fileUrl = [aDecoder decodeObjectForKey:KEY_USER_IMAGE_URL];
        
        // 一起设置值
        if (! isEmptyString(token.token) && user.identifier > 0) {
            self.token = token;
            self.user = user;
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.openIdFrom3rdParty forKey:KEY_USER_3RD_PARTY_OPENID];
//    [aCoder encodeObject:self.tokenFrom3rdParty forKey:KEY_USER_3RD_PARTY_TOKEN];
//    [aCoder encodeObject:self.imageUrlFrom3rdParty forKey:KEY_USER_3RD_PARTY_IMAGE_URL];
//    [aCoder encodeObject:self.nickNameFrom3rdParty forKey:KEY_USER_3RD_PARTY_NICK_NAME];
//    [aCoder encodeObject:self.expirationDateFrom3rdParty forKey:KEY_USER_3RD_PARTY_EXPIRATION];
    
    [aCoder encodeObject:@(self.loginType) forKey:KEY_USER_LOGIN_TYPE];
    
//    [aCoder encodeObject:@(self.isBindPhone) forKey:KEY_USER_BIND_PHONE];
    
    [aCoder encodeObject:self.token.token forKey:KEY_USER_TOKEN];
    [aCoder encodeObject:self.token.refreshToken forKey:KEY_USER_REFRESH_TOKEN];
    [aCoder encodeObject:self.token.expiresAt forKey:KEY_USER_EXPIRATION];
    
    [aCoder encodeObject:@(self.user.identifier) forKey:KEY_USER_ID];
    [aCoder encodeObject:self.user.nickName forKey:KEY_USER_NICKNAME];
    [aCoder encodeObject:@(self.user.level) forKey:KEY_USER_LEVEL];
    [aCoder encodeObject:self.user.bind forKey:KEY_USER_BIND];
    [aCoder encodeObject:self.user.phone forKey:KEY_USER_PHONE];
//    [aCoder encodeObject:self.user.headerImage.fileUrl forKey:KEY_USER_IMAGE_URL];
    
}

#pragma mark - cache with NSUserDefaults

+ (MZLAppUser *)loadUserFromPreference {
    return [COPreferences getCodedUserPreference:MZL_KEY_CACHED_APP_USER];
}

+ (void)removeUserFromPreference {
    [COPreferences removeUserPreference:MZL_KEY_CACHED_APP_USER];
}

- (void)saveInPreference {
    [COPreferences archiveUserPreference:self forKey:MZL_KEY_CACHED_APP_USER];
}

#pragma mark - helper methods

- (void)setUser:(MZLModelUser *)user token:(MZLModelAccessToken *)token {
    self.user = user;
    self.token = token;
}

@end
