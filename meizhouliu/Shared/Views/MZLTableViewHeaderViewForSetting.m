//
//  MZLTableViewHeadViewForSetting.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLTableViewHeaderViewForSetting.h"

@implementation MZLTableViewHeaderViewForSetting

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

+ (id)headerViewInstance:(CGSize)parentViewSize {
    MZLTableViewHeaderViewForSetting *view = [MZLTableViewHeaderViewForSetting viewFromNib:@"MZLTableViewHeadViewForSetting"];
    view.frame = CGRectMake(0, 0, parentViewSize.width, parentViewSize.height);
    [view setBackgroundColor:MZL_BG_COLOR()];
    [view.lblNickName setTextColor:colorWithHexString(@"#555555")];
    return view;
}
@end
