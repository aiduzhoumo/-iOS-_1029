//
//  MZLLocationHeaderInfo.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-16.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MZLModelLocation;

@interface MZLLocationHeaderInfo : NSObject

@property (nonatomic, assign) CGFloat startY;
@property (nonatomic, assign) CGFloat endY;

@property (nonatomic, strong) MZLModelLocation *location;

+ (MZLLocationHeaderInfo *)instanceFromDictionary:(NSDictionary *)dict;
- (void)verifyHeightGreaterOrEqualTo:(CGFloat)minimumHeight;

@end
