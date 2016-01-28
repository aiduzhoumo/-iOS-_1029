//
//  MZLPhoneLoginSvcParam.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/25.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZLPhoneLoginSvcParam : NSObject

@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *passWord;
@property (nonatomic, copy) NSString *machineId;

- (NSDictionary *)toDictionary;

+ (MZLPhoneLoginSvcParam *)phoneLoginSvcParamWithPhoneNum:(NSString *)phoneNum password:(NSString *)password;

+ (instancetype)instance;

@end
