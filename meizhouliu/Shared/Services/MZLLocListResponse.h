//
//  MZLLocListResponse.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-7-8.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZLLocListResponse : NSObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSArray *destinations;
@property (nonatomic, strong) NSArray *more;

- (BOOL)isSystemLocationList;
- (BOOL)isDefaultLocationList;
- (BOOL)isSpecialLocationList;

@end
