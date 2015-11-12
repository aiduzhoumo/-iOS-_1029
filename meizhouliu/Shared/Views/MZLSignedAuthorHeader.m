//
//  MZLSignedAuthorHeader.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-29.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLSignedAuthorHeader.h"
#import "MZLModelUser.h"
#import "UIImageView+MZLNetwork.h"

@implementation MZLSignedAuthorHeader

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

+ (id)signedAuthorHeader:(MZLModelUser *)author {
    MZLSignedAuthorHeader *result = [UIView viewFromNib:@"MZLSignedAuthorHeader"];
//    result.backgroundColor = colorWithHexString(@"#f9fafa");
    [result initWithAuthorInfo:author];
    result.vwBg.backgroundColor = [colorWithHexString(@"#ffffff") colorWithAlphaComponent:0.9];
    [result.imgCover loadAuthorCoverFromURL:author.coverUrl];
    return result;
}

@end
