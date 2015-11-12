//
//  MZLLocDetailTableFooterView.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-6-5.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLLocDetailTableFooterView.h"
#import "MZLModelLocationDetail.h"
#import "UIImageView+MZLNetwork.h"
#import "MZLModelImage.h"

@implementation MZLLocDetailTableFooterView

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

+ (id)instance:(MZLModelLocationDetail *)locationDetail {
    MZLLocDetailTableFooterView *result = [UIView viewFromNib:@"MZLLocDetailTableFooterView"];
    result.lblLocation.textColor = MZL_COLOR_BLACK_555555();
    result.lblLocation.text = locationDetail.name;
    [result.imgLocation loadSmallLocationImageFromURL:locationDetail.coverImageUrl];
    return result;
}

@end
