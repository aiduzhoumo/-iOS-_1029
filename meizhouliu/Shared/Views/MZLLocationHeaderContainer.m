//
//  MZLLocationHeaderContainer.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-19.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLLocationHeaderContainer.h"
#import "WeView.h"
#import "MZLLocationHeaderInfo.h"

@implementation MZLLocationHeaderContainer

+ (MZLLocationHeaderContainer *)headerContainer:(MZLLocationHeaderInfo *)headerInfo parentScroll:(UIScrollView *)parentScroll parentAttachView:(UIView *)parentAttachView topBarHeight:(CGFloat)topBarHeight {
    MZLLocationHeaderContainer *result = [[MZLLocationHeaderContainer alloc]init];
    result.parentAttachView = parentAttachView;
    result.parentScroll = parentScroll;
    result.headerInfo = headerInfo;
    CGFloat topY = result.headerInfo.startY;
    CGFloat bottomY = result.headerInfo.endY - HEIGHT_LOCATION_HEADER;
    result.topView = [MZLLocationHeaderView headerView:headerInfo container:result y:topY];
//    result.topView.backgroundColor = [UIColor blueColor];
    [parentScroll addSubview:result.topView];
    if (topY == bottomY) {     //两者重合
        result.bottomView = result.topView;
    } else {
        result.bottomView = [MZLLocationHeaderView headerView:headerInfo container:result y:bottomY];
        [parentScroll addSubview:result.bottomView];
        result.bottomView.hidden = YES;
//        result.bottomView.backgroundColor = [UIColor redColor];
        CGFloat attachY = topBarHeight + ATTACHED_LOCATION_HEADER_TOP_MARGIN;
        // 当topView与bottomView不重合时生成attachView
        result.attachView = [MZLLocationHeaderView headerView:headerInfo container:result y:attachY];
//    [parentAttachView addSubview:result.attachView];
//    result.attachView.backgroundColor = [UIColor redColor];
    }

    return result;
}

- (BOOL)isAttached {
    return self.attachView.superview != nil;
}

- (CGFloat)containerHeight {
    return self.headerInfo.endY - self.headerInfo.startY;
}

- (void)handleYPosition:(CGFloat)y {
    // 两者重合时其实只有一个View，不用考虑位置变换
    if (self.topView == self.bottomView) {
        return;
    }
    
    if ([self isAttached]) {
        if (y > [self attachStartY] && y < [self attachEndY]) {
            return;
        }
        [self.attachView removeFromSuperview];
        if (y <= [self attachStartY]) {
            self.topView.hidden = NO;
            self.bottomView.hidden = YES;
        } else if (y >= [self attachEndY]) {
            self.bottomView.hidden = NO;
            self.topView.hidden = YES;
        }
    } else {
        if (y <= [self attachStartY]) {
            self.topView.hidden = NO;
            self.bottomView.hidden = YES;
        } else if (y >= [self attachEndY]) {
            self.bottomView.hidden = NO;
            self.topView.hidden = YES;
        } else if (y >= [self attachStartY] && y < [self attachEndY]) {
            self.topView.hidden = YES;
            self.bottomView.hidden = YES;
            [self.parentAttachView addSubview:self.attachView];
        }
    }
}

- (CGFloat)attachStartY {
    return self.headerInfo.startY - ATTACHED_LOCATION_HEADER_TOP_MARGIN;
    // return self.topView.y - ATTACHED_LOCATION_HEADER_TOP_MARGIN;
}

- (CGFloat)attachEndY {
    return self.headerInfo.endY - HEIGHT_LOCATION_HEADER - ATTACHED_LOCATION_HEADER_TOP_MARGIN;
    //return self.bottomView.y - ATTACHED_LOCATION_HEADER_TOP_MARGIN;
}

- (void)addTapGestureRecognizer:(id)target action:(SEL)selector {
    [self.topView addTapGestureRecognizer:target action:selector];
    if (self.topView != self.bottomView) {
        [self.bottomView addTapGestureRecognizer:target action:selector];
        [self.attachView addTapGestureRecognizer:target action:selector];
    }
}

- (void)removeFromParent {
    [self.topView removeFromSuperview];
    if (self.topView != self.bottomView) {
        [self.bottomView removeFromSuperview];
    }
    [self.attachView removeFromSuperview];
}

+ (void)adjustHeadersInfo:(NSArray *)headersInfo {
    // 1.如果startY与endY之间不足Height高度，补足高度 2.如果当前info与nextInfo不重合
    if (headersInfo.count == 0) {
        return;
    }
    MZLLocationHeaderInfo *headerInfo = headersInfo[0];
    CGFloat minimumHeight = HEIGHT_LOCATION_HEADER;
    [headerInfo verifyHeightGreaterOrEqualTo:minimumHeight];
    for (int i = 1; i < headersInfo.count; i++) {
        MZLLocationHeaderInfo *temp = headersInfo[i];
        // 先保障不重合
        if (temp.startY < headerInfo.endY) {
            temp.startY = headerInfo.endY;
        }
        // 再保障最小高度
        [temp verifyHeightGreaterOrEqualTo:minimumHeight];
        headerInfo = temp;
    }
}

@end
