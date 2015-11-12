//
//  MZLNormalAuthorHeader.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-29.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLNormalAuthorHeader.h"
#import "UIView+COAdditions.h"
#import "UIImageView+MZLNetwork.h"

@implementation MZLNormalAuthorHeader

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

+ (id)normalAuthorHeader:(MZLModelUser *)author {
    MZLNormalAuthorHeader *result = [UIView viewFromNib:@"MZLNormalAuthorHeader"];
    result.backgroundColor = colorWithHexString(@"#f9fafa");
    [result initWithAuthorInfo:author];
    return result;
}

@end
