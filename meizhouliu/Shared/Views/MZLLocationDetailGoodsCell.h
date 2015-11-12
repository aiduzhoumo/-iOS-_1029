//
//  MZLLocationDetailGoodsCell.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-19.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MZL_LD_GOODS_CELL_REUSE_ID @"MZLLocationDetailGoodsCell"
#define MZL_LD_GOODS_CELL_HEIGHT 104

@class MZLModelGoods;

@interface MZLLocationDetailGoodsCell : UITableViewCell

- (void)updateWithModel:(MZLModelGoods *)model;

@end
