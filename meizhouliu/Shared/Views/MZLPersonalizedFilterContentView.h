//
//  MZLPersonalizedFilterContentView.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-12-15.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLFilterContentView.h"

@protocol MZLPersonalizedFilterContentViewDelegate <NSObject>

@optional
- (void)onSkipFilter;

@end

@class MZLPersonalizedViewController;

@interface MZLPersonalizedFilterContentView : MZLFilterContentView

+ (instancetype)instanceWithFilterOptions:(NSArray *)filterOptions;

@property (nonatomic, weak) id<MZLPersonalizedFilterContentViewDelegate> owner;

@end
