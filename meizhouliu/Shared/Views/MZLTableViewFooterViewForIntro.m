//
//  MZLTableViewFooterViewForIntro.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLTableViewFooterViewForIntro.h"

@implementation MZLTableViewFooterViewForIntro

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
+ (id)footerViewInstance:(CGSize)parentViewSize {
    MZLTableViewFooterViewForIntro *view = [MZLTableViewFooterViewForIntro viewFromNib:@"MZLTableViewFooterViewForIntro"];
    [view.vwEmpty setBackgroundColor:MZL_BG_COLOR()];
    [view.lblIntro setTextColor:MZL_COLOR_BLACK_555555()];
    return view;
}
@end
