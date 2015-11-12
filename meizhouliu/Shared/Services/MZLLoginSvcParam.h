//
//  MZLLoginSvcParam.h
//  mzl_mobile_ios
//
//  Created by alfred on 14-7-31.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZLLoginSvcParam : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *password;

- (NSDictionary *)toDictionary;

+ (MZLLoginSvcParam *)loginSvcParamWithname:(NSString *)name password:(NSString *)password;
@end
