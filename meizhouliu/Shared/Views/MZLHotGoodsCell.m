//
//  MZLHotGoodsCell.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15/4/20.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLHotGoodsCell.h"
#import "UIImageView+MZLNetwork.h"
#import "NSString+MZLImageURL.h"
#import "UIImageView+WebCache.h"
#import "MZLMockData.h"
#import "MZLModelGoods.h"

@interface MZLHotGoodsCell () {
    
}

@property (weak, nonatomic) IBOutlet UIImageView *imgGoods;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceTip;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation MZLHotGoodsCell

- (void)awakeFromNib {
    // Initialization code
    self.imgGoods.backgroundColor = @"EEEEEE".co_toHexColor;
    for (UILabel *lbl in @[self.lblPrice, self.lblPriceTip]) {
        lbl.textColor = @"FFD521".co_toHexColor;
    }
    self.lblTitle.preferredMaxLayoutWidth = CO_SCREEN_WIDTH - 2 * 24.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)updateWithGoods:(MZLModelGoods *)goods {
    self.lblPrice.text = INT_TO_STR(goods.price);
    self.lblTitle.text = goods.title;
    [self.imgGoods sd_setImageWithURL:[NSURL URLWithString:goods.imageUrl] placeholderImage:nil];
   
//    [self.imgGoods loadImageFromURL:goods.coverImg.fileUrl placeholderImageName:nil mode:MZL_IMAGE_MODE_SCALED callbackOnImageLoaded:nil];
}

+ (CGFloat)cellHeigth {
    return CO_SCREEN_WIDTH * 3.0 / 4.0;
}

@end
