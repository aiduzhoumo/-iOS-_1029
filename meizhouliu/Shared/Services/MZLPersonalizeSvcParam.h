//
//  MZLPersonalizeSvcParam.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-12-16.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+CODictionaryParameter.h"

@interface MZLPersonalizeSvcParam : NSObject

@property (nonatomic, copy) NSString *currentLocationName;
@property (nonatomic, assign) NSInteger topLocationId;
@property (nonatomic, assign) NSInteger categoryId;

+ (instancetype)instanceWithCurLocation:(NSString *)curLocation topLocationId:(NSInteger)topLocationId categoryId:(NSInteger)categoryId;

@end
