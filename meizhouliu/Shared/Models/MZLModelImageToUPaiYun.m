//
//  MZLModelImageToUPaiYun.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/30.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import "MZLModelImageToUPaiYun.h"

@implementation MZLModelImageToUPaiYun

+ (NSMutableDictionary *)attributeDictionary {
    return [[super attributeDictionary] fromPath:@"path" toProperty:@"path"];
}

@end
