//
//  MZLImageUpLoadToUPaiYunResponse.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/30.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import "MZLServiceResponseObject.h"
#import "MZLModelImageToUPaiYun.h"
#import "MZLUpYunConfig.h"

@interface MZLImageUpLoadToUPaiYunResponse : MZLServiceResponseObject

@property (nonatomic, strong) MZLModelImageToUPaiYun *image;
@property (nonatomic, strong) MZLUpYunConfig *config;
@property (nonatomic, copy) NSString *bucket;
@end
