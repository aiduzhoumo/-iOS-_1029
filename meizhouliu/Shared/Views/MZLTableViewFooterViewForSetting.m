//
//  MZLTableViewFooterViewForSetting.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLTableViewFooterViewForSetting.h"

@implementation MZLTableViewFooterViewForSetting

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
    MZLTableViewFooterViewForSetting *view = [MZLTableViewFooterViewForSetting viewFromNib:@"MZLTableViewFooterViewForSetting"];
    view.frame = CGRectMake(0, 0, parentViewSize.width, MZLSettingFooterViewHeight);
    [view.vwEmpty setBackgroundColor:MZL_BG_COLOR()];
    [view.btnLogout setTintColor:colorWithHexString(@"#f83030")];
    return view;
}
@end
