//
//  MZLLocationInfo.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-9.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZLLocationInfo : NSObject <NSCoding>

@property (copy, nonatomic) NSNumber *latitude;
@property (copy, nonatomic) NSNumber *longitude;
@property (copy, nonatomic) NSString *city;

@end
