//
//  MZLGoodsItemCell.h
//  mzl_mobile_ios
//
//  Created by race on 14/12/5.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZLModelGoodsDetail;
@interface MZLGoodsItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgGoods;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imgLeftQuote;
@property (weak, nonatomic) IBOutlet UIImageView *imgRightQuote;


@property (assign, nonatomic) BOOL isVisted;

- (void)updateOnFirstVisit;
- (void)updateContentFromGoods:(MZLModelGoodsDetail *)goodsDetail;
@end
