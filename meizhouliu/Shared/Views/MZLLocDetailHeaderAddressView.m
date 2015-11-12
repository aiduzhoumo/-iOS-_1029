//
//  MZLLocDetailHeaderAddressView.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-6-5.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLLocDetailHeaderAddressView.h"
#import "MZLModelLocationDetail.h"
#import "UILabel+COAdditions.h"

@implementation MZLLocDetailHeaderAddressView

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

+ (id)instance:(MZLModelLocationDetail *)locationDetail userLocPref:(MZLModelUserLocationPref *)userLocPref {
//    MZLLocDetailHeaderAddressView *result = [UIView viewFromNib:@"MZLLocDetailHeaderAddressView"];
    MZLLocDetailHeaderAddressView *result = [[MZLLocDetailHeaderAddressView alloc] init];

    WeView *leftView = [[WeView alloc] init];
    [leftView setHStretches];
    [leftView setHasCellVAlign:YES];
    
    UILabel *lblName = [[UILabel alloc] init];
    [lblName setHasCellHAlign:YES];
    result.lblName = lblName;
    lblName.textColor = MZL_COLOR_BLACK_555555();
    lblName.font = MZL_BOLD_FONT(25.0);
    lblName.numberOfLines = 0;
    [lblName setMaxDesiredWidth:230.0];
    lblName.text = locationDetail.name;
    CGSize lblSize = [lblName sizeThatFits:CGSizeMake(230.0, 0.0)];
    if (lblSize.height > 30) {
        [lblName setFixedDesiredHeight:60.0];
    }
    
    [[[[leftView addSubviewsWithVerticalLayout:@[lblName]]
      setLeftMargin:15.0]
     setTopMargin:20.0]
     setHAlign:H_ALIGN_LEFT];
    
//    WeView *rightView = [[WeView alloc] init];
////    rightView.backgroundColor = [UIColor grayColor];
//    result.vwInterestClickable = rightView;
//    [rightView setHasCellVAlign:YES];
//    UIImageView *image = [[UIImageView alloc] init];
//    result.image = image;
//    [image setFixedDesiredSize:CGSizeMake(48.0, 48.0)];
//    [[[rightView addSubviewsWithVerticalLayout:@[image]]
//      setHMargin:15.0]
//     setVMargin:10.0];
    
    [[[result addSubviewsWithHorizontalLayout:@[leftView]]
      setBottomMargin:20.0]
     setVAlign:V_ALIGN_TOP];
//    [result toggleImage:userLocPref];
    return result;
}

//- (void)toggleImage:(MZLModelUserLocationPref *)userLocPref {
//    if (userLocPref) {
//        self.image.image = [UIImage imageNamed:@"LD_Favored"];
//    } else {
//        self.image.image = [UIImage imageNamed:@"LD_Favor"];
//    }
//}

@end
