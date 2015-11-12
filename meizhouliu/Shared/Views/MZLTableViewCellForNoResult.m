//
//  MZLTableViewCellForNoResult.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-17.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLTableViewCellForNoResult.h"

@implementation MZLTableViewCellForNoResult

- (void)awakeFromNib
{
    // Initialization code
    self.lblMain.text = @"";
    self.lblDetail.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
