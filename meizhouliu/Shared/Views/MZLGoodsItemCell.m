//
//  MZLGoodsItemCell.m
//  mzl_mobile_ios
//
//  Created by race on 14/12/5.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLGoodsItemCell.h"
#import "MZLModelGoodsDetail.h"
#import "UIImageView+MZLNetwork.h"

@implementation MZLGoodsItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark -  UI for cell

- (void)updateOnFirstVisit {
    self.isVisted = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.lblTitle.textColor = colorWithHexString(@"#434343");
    self.lblPrice.textColor = colorWithHexString(@"#ff9000");
    self.lblDescription.textColor = colorWithHexString(@"#b0b0b0");
    self.lblDescription.numberOfLines = 4;
     self.lblDescription.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)updateContentFromGoods:(MZLModelGoodsDetail *)goodsDetail {
   
    [self.imgGoods loadSmallLocationImageFromURL:goodsDetail.goodsInfo.coverImg.fileUrl];
    self.lblTitle.text = goodsDetail.goodsInfo.title;
    self.lblPrice.text = [NSString stringWithFormat:@"%@",@(goodsDetail.goodsInfo.price)];
    
    if (isEmptyString(goodsDetail.goodsDesp)) {
        self.imgLeftQuote.visible = NO;
        self.imgRightQuote.visible = NO;
        self.lblDescription.visible = NO;
    }else {
        self.imgLeftQuote.visible = YES;
        self.imgRightQuote.visible = YES;
        self.lblDescription.visible = YES;
        self.lblDescription.text = goodsDetail.goodsDesp;
    }
}

@end
