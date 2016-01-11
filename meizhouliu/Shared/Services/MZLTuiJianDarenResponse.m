//
//  MZLTuiJianDarenResponse.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/8.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import "MZLTuiJianDarenResponse.h"
#import "MZLTuiJianDaren.h"

@implementation MZLTuiJianDarenResponse

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
    [mapping addRelationFromPath:@"tuijiandaren" toProperty:@"tuijian" withMapping:[MZLTuiJianDaren rkObjectMapping]];
}

@end
