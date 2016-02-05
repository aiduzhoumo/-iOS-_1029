//
//  MZLUpYunConfig.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/30.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+CORestKitMapping.h"
#import "NSObject+CODictionaryParameter.h"

@interface MZLUpYunConfig : NSObject

@property (nonatomic, copy) NSString *policy;
@property (nonatomic, copy) NSString *signature;

@end
