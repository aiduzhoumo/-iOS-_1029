//
//  MZLUpYunConfig.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/30.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import "MZLUpYunConfig.h"

@implementation MZLUpYunConfig

+ (NSMutableDictionary *)attributeDictionary {
    return [[[super attributeDictionary]
             fromPath:@"policy" toProperty:@"policy"]
            fromPath:@"signature" toProperty:@"signature"];
}

@end
