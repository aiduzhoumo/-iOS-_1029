//
//  MZLVerifyCodeSvcParam.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/25.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZLVerifyCodeSvcParam : NSObject

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *code;

- (NSMutableDictionary *)toDictionary;


@end
