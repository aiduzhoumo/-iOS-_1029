//
//  MZLLocationRouteInfo.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-27.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZLModelLocationBase.h"

@interface MZLLocationRouteInfo : NSObject

/* start from 1 */
@property (nonatomic, assign) NSInteger days;
/* start from 1 */
@property (nonatomic, assign) NSInteger daysRouteIndex;
/* start from 1 */
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) MZLModelLocationBase *location;

@property (nonatomic, readonly) NSInteger locationId;

@end
