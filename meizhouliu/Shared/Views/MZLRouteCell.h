//
//  MZLRouteCell.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-20.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEIGHT_ROUTE_CELL 60.0

@interface MZLRouteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgBg;
@property (weak, nonatomic) IBOutlet UIImageView *imgBubble;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblIndex;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;

@property (weak, nonatomic) IBOutlet UIView *vwLineTop;
@property (weak, nonatomic) IBOutlet UIView *vwLineBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cLblSpacing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cLblLocationTrailing;

- (void)adjustLayout;

- (void)initCellColors;
@end
