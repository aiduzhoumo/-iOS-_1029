//
//  MZLModelImage.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-23.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelImage.h"

@implementation MZLModelImage

+ (NSMutableDictionary *)attributeDictionary {
    return [[super attributeDictionary] fromPath:@"file_url" toProperty:@"fileUrl"];
}

@end
