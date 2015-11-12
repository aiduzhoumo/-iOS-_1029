//
//  MZLLocationItemCell.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-25.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLLocationItemCell.h"
#import "UIImageView+MZLNetwork.h"
#import "MZLModelLocation.h"
#import "MZLModelRelatedLocation.h"
#import "MZLModelRelatedLocationExt.h"
#import "MZLModelImage.h"
#import "UITableViewCell+MZLAddition.h"
#import "MZLServices.h"
#import "MZLDescendantsParam.h"


@implementation MZLLocationItemCell

- (void)awakeFromNib
{
    // Initialization code
    self.imgLocation.layer.cornerRadius = 3.0;
    self.imgLocation.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)willTransitionToState:(UITableViewCellStateMask)state{
    [super willTransitionToState:state];
    [self mzl_checkAndReplaceDeleteControl:state];
}

- (void)updateOnFirstVisit{
    self.isVisted = YES;
    self.lblName.numberOfLines = 1;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = [UIColor whiteColor];
    self.lblName.textColor = MZL_COLOR_BLACK_555555();
    self.lblTags.textColor = MZL_COLOR_BLACK_999999();
    self.lblDetails.textColor = colorWithHexString(@"#B0B0B0");
    self.lblAddress.textColor = colorWithHexString(@"#B0B0B0");
    self.vwLblTotalBg.backgroundColor = colorWithHexString(@"#D8D8D8");
    self.vwLblTagBg.backgroundColor = colorWithHexString(@"#D8D8D8");
    self.vwLblTotalBg.layer.cornerRadius = self.vwLblTotalBg.frame.size.height/2;
    self.vwLblTagBg.layer.cornerRadius = self.vwLblTagBg.frame.size.height/2;
    
}

// 想去目的地展示逻辑
- (void)updateContentFromLocation:(MZLModelLocationBase *)location {
    self.lblName.text = location.name;
    if (isEmptyString(location.address)) {
        self.imgPin.visible = NO;
        self.lblAddress.visible = NO;
    }else {
        self.lblAddress.text = location.address;
    }
    self.lblTags.text = location.tagsStr;
    self.lblDetails.text = [NSString stringWithFormat:@"%@种",@(location.shortArticleCount)];
    [self.imgLocation loadSmallLocationImageFromURL:location.coverImageUrl];
}

// 相关目的地展示逻辑
- (void)updateContentFromRelatedLocation:(MZLModelLocationBase *)location {
    self.lblName.text = location.name;
    self.lblTags.text = location.tagsStr;
    self.lblDetails.text = [NSString stringWithFormat:@"%@种",@(location.shortArticleCount)];
    self.location = location;
    [self updateLocationExtInfo];
}

- (void)updateLocationExtInfo {
    if (self.location.locationExt && self.location.coverImage) {
        [self _updateLocationExtInfo];
    } else {
        [self.imgLocation loadSmallLocationImageFromURL:self.location.coverImageUrl];
        __weak MZLLocationItemCell *weakSelf = self;
        MZLDescendantsParam *desParam = [MZLDescendantsParam descendantsParamsFromDescendants:@[@(self.location.identifier)]];
        [MZLServices relatedLocationPersonalizeExtService:self.parentLocation param:desParam succBlock:^(NSArray *models) {
            //有可能在service返回之前，cell被回收重用，所以需要检查location是否改变
            MZLModelRelatedLocationExt *relatedLocationExt = (MZLModelRelatedLocationExt *)models[0];
            if (relatedLocationExt.identifier == self.location.identifier) {
                self.location.locationExt = relatedLocationExt.locatinExt;
                self.location.coverImage = relatedLocationExt.coverImg;
                [weakSelf _updateLocationExtInfo];
            }
        } errorBlock:^(NSError *error) {
        }];
    }
}

- (void)_updateLocationExtInfo{
    if (isEmptyString(self.location.address)) {
        self.imgPin.visible = NO;
        self.lblAddress.visible = NO;
    }else {
        self.lblAddress.text = self.location.address;
    }
    [self.imgLocation loadSmallLocationImageFromURL:self.location.coverImageUrl];
}

@end
