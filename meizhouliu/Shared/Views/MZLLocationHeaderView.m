//
//  MZLLocationHeaderView.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-16.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLLocationHeaderView.h"
#import "MZLLocationHeaderInfo.h"
#import "MZLModelLocation.h"

#define INSET_HORIZENTAL 10.0
#define INSET_VERTICAL 5.0

#define SPACING 10.0

@implementation MZLLocationHeaderView

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

+ (MZLLocationHeaderView *)headerView:(MZLLocationHeaderInfo *)headerInfo container:(MZLLocationHeaderContainer *)container y:(CGFloat)y {
    UIWindow *window = globalWindow();
    
    // 加入左边圆角的View
    CGFloat leftRoundCornerViewWidth = 7.0;
    UIImageView *leftRoundCornerImage = [[UIImageView alloc] init];
    leftRoundCornerImage.image = [UIImage imageNamed:@"ArticleDetail_Hd_LfRdCorner"];
    [leftRoundCornerImage setFixedDesiredWidth:leftRoundCornerViewWidth];
    [leftRoundCornerImage setFixedDesiredHeight:HEIGHT_LOCATION_HEADER_VISIBLE];
    //leftRoundCornerView.layer.cornerRadius = 5.0;
    //leftRoundCornerView.backgroundColor = [colorWithHexString(@"#63b8a8") colorWithAlphaComponent:0.8];
    [leftRoundCornerImage setHasCellHAlign:YES];
    
    UIImageView *locationImage = [[UIImageView alloc]init];
    locationImage.image = [UIImage imageNamed:@"ArticleDetail_Hd_Loc"];
    [locationImage setFixedDesiredWidth:9.0];
    [locationImage setFixedDesiredHeight:12.0];
    locationImage.hasCellHAlign = YES;
    UILabel *lblLocationName = [[UILabel alloc]init];
    lblLocationName.textColor = [UIColor whiteColor];
    lblLocationName.font = MZL_FONT(14.0);
    lblLocationName.text = headerInfo.location.name; // INT_TO_STR(headerInfo.location.identifier);
    [lblLocationName setMaxDesiredWidth:150.0];
    lblLocationName.hasCellHAlign = YES;
    WeView *rightView = [[WeView alloc]init];
    [rightView setFixedDesiredHeight:HEIGHT_LOCATION_HEADER_VISIBLE];
    [rightView setHStretches];
    [[[[[[rightView addSubviewsWithHorizontalLayout:@[locationImage,lblLocationName]]
         setLeftMargin:INSET_HORIZENTAL - leftRoundCornerViewWidth]
        setRightMargin:INSET_HORIZENTAL]
       setVMargin:INSET_VERTICAL]
      setHSpacing:SPACING]
     setHAlign:H_ALIGN_LEFT];
    
    WeView *contentView = [[WeView alloc]init];
    [[[[contentView addSubviewWithCustomLayout:leftRoundCornerImage]
       setHMargin:0.0]
      setVMargin:0.0]
     setHAlign:H_ALIGN_LEFT];
    [[[[contentView addSubviewWithCustomLayout:rightView]
       setLeftMargin:leftRoundCornerViewWidth]
      setVMargin:0.0]
     setHAlign:H_ALIGN_LEFT];
    rightView.backgroundColor = [colorWithHexString(@"#63b8a8") colorWithAlphaComponent:0.8];
    
    CGSize fitsSize = [contentView sizeThatFits:CGSizeMake(window.width, HEIGHT_LOCATION_HEADER)];
//    NSLog(@"%f,%f", fitsSize.width, fitsSize.height);
    CGFloat x = window.width - fitsSize.width;
    MZLLocationHeaderView *result = [[MZLLocationHeaderView alloc] initWithFrame:CGRectMake(x, y, fitsSize.width, HEIGHT_LOCATION_HEADER)];
    [[result addSubviewsWithVerticalLayout:@[contentView]]
     setVMargin:VERTICAL_INSET_LOCATION_HEADER];
    
    result.headerInfo = headerInfo;
    result.container = container;
    return result;
}

@end
