//
//  MZLLocationItemCell.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-25.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLChildLocationsSvcParam.h"

@class MZLModelLocationBase;

@interface MZLLocationItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblTags;
@property (weak, nonatomic) IBOutlet UILabel *lblDetails;
@property (weak, nonatomic) IBOutlet UIView *vwLblTotalBg;
@property (weak, nonatomic) IBOutlet UIView *vwLblTagBg;
@property (weak, nonatomic) IBOutlet UIImageView *imgPin;

//@property (strong, nonatomic) MZLChildLocationsSvcParam *locSvcParam;
//@property (strong, nonatomic) MZLModelRelatedLocationExt *locationExt;
@property (strong, nonatomic) MZLModelLocationBase *parentLocation;
@property (strong, nonatomic) MZLModelLocationBase *location;

@property (assign, nonatomic) BOOL isVisted;

- (void)updateOnFirstVisit;
- (void)updateContentFromLocation:(MZLModelLocationBase *)location;
- (void)updateContentFromRelatedLocation:(MZLModelLocationBase *)location;
- (void)updateLocationExtInfo;

@end
