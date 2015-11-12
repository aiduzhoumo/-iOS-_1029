//
//  MZLLocationHeaderContainer.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-19.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZLLocationHeaderView.h"

#define ATTACHED_LOCATION_HEADER_TOP_MARGIN 0.0

@class WeView, MZLLocationHeaderInfo;

@interface MZLLocationHeaderContainer : NSObject

@property (nonatomic, readonly) BOOL isAttached;

/** 在所有的headers当中所处的位置, start from 1 */
@property (nonatomic, assign) NSInteger position;

@property (nonatomic, strong) MZLLocationHeaderInfo *headerInfo;

@property (nonatomic, strong) MZLLocationHeaderView *topView;
@property (nonatomic, strong) MZLLocationHeaderView *bottomView;
@property (nonatomic, strong) MZLLocationHeaderView *attachView;

@property (nonatomic, weak) UIScrollView *parentScroll;
@property (nonatomic, weak) UIView *parentAttachView;

- (void)handleYPosition:(CGFloat)y;
- (void)addTapGestureRecognizer:(id)target action:(SEL)selector;
- (void)removeFromParent;

+ (MZLLocationHeaderContainer *)headerContainer:(MZLLocationHeaderInfo *)headerInfo parentScroll:(UIScrollView *)parentScroll parentAttachView:(UIView *)parentAttachView topBarHeight:(CGFloat)topBarHeight;
+ (void)adjustHeadersInfo:(NSArray *)headersInfo;

@end
