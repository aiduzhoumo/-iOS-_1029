//
//  MZLShortAcleChooseLocItemCellTableViewCell.m
//  mzl_mobile_ios
//
//  Created by race on 14/12/29.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLShortArticleChooseLocItemCell.h"
#import "MZLModelSurroundingLocations.h"
#import "masonry.h"

#define SHOR_ARTICIL_CELL_LOCNAME_HMARGIN 30
#define SHOR_ARTICIL_CELL_LOCADDRESS_HMARGIN 47

@interface MZLShortArticleChooseLocItemCell ()
@end

@implementation MZLShortArticleChooseLocItemCell

- (void)awakeFromNib {
    // Initialization code
    self.lblLocName.preferredMaxLayoutWidth = CO_SCREEN_WIDTH - SHOR_ARTICIL_CELL_LOCNAME_HMARGIN;
    self.lblLocAddress.preferredMaxLayoutWidth = CO_SCREEN_WIDTH - SHOR_ARTICIL_CELL_LOCADDRESS_HMARGIN;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)updateOnFirstVisit {
    self.isVisted = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.lblLocName.textColor = colorWithHexString(@"#434343");
    self.lblLocAddress.textColor = colorWithHexString(@"b0b0b0");
}

- (void)updateContentWithLocationInfo:(MZLModelSurroundingLocations *)location {
    self.lblLocName.text = location.locationName;
    self.lblLocAddress.text = location.address;
}

@end
