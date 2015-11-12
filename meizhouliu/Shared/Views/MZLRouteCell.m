//
//  MZLRouteCell.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-20.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLRouteCell.h"
#import "UILabel+COAdditions.h"

@implementation MZLRouteCell


- (void)awakeFromNib
{
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.vwLineBottom.backgroundColor = colorWithHexString(@"#ffc6c6");
    self.vwLineTop.backgroundColor = colorWithHexString(@"#ffc6c6");
    [self initCellColors];
}

- (void)initCellColors{
    self.lblLocation.textColor = MZL_COLOR_GREEN_61BAB3();
    self.lblAddress.textColor = colorWithHexString(@"cccccc");
    self.contentView.backgroundColor = [UIColor clearColor];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)adjustLayout {
    CGFloat lblLocationWidth = [self.lblLocation textSizeForSingleLine].width;
    if (lblLocationWidth > 144.0) { // 大概9个汉字的长度
        self.cLblSpacing.constant = 0.0;
        self.cLblLocationTrailing.constant = 0.0;
        self.lblAddress.hidden = YES;
    } else {
        self.cLblSpacing.constant = 10.0;
        self.cLblLocationTrailing.constant = 10.0;
        self.lblAddress.hidden = NO;
    }
//    [self setNeedsLayout];
}

@end
