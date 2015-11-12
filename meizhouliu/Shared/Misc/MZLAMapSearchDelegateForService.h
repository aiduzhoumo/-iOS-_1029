//
//  MZLAMapSearchDelegateForService.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15/4/23.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchAPI.h>


@interface MZLAMapSearchDelegateForService : NSObject <AMapSearchDelegate>

@property (nonatomic, copy) void(^ svcSuccBlock)(NSArray *models);
@property (nonatomic, copy) void(^ svcErrorBlock)(NSError *error);

+ (instancetype)sharedInstance;

@end
