//
//  MZLLocationDetailGoodsCell.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-19.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLLocationDetailGoodsCell.h"
#import "MZLModelGoods.h"
#import "UIImageView+MZLNetwork.h"
#import "UIImageView+WebCache.h"

@interface MZLLocationDetailGoodsCell () {
    
}

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblSold;
@property (weak, nonatomic) IBOutlet UIView *vwPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceTip1;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceTip2;


@end

@implementation MZLLocationDetailGoodsCell

- (void)awakeFromNib {
    // Initialization code
    [self initInternal];
}

- (void)initInternal {
    self.goodsImage.layer.cornerRadius = 3;
    self.goodsImage.clipsToBounds = YES;
    self.lblDetail.numberOfLines = 2;
    self.lblDetail.textColor = colorWithHexString(@"#434343");
    self.lblSold.textColor = colorWithHexString(@"#999999");
    self.lblPriceTip1.textColor = colorWithHexString(@"#434343");
    self.lblPriceTip2.textColor = colorWithHexString(@"#434343");
    self.lblPrice.font = MZL_BOLD_FONT(18);
    self.lblPrice.textColor = colorWithHexString(@"#626A80");
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithModel:(MZLModelGoods *)model {
    self.lblDetail.text = model.title;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"Default_Loc_Small"]];
//    [self.goodsImage loadSmallLocationImageFromURL:model.imageUrl];
    self.lblSold.hidden = YES;
//    self.lblSold.text = [NSString stringWithFormat:@"已售%d", model.sold];
    self.vwPrice.hidden = (model.price <= 0);
    self.lblPrice.text = INT_TO_STR(model.price);
}

@end
