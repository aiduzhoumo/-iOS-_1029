//
//  MZLHotGoodsCell.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15/4/20.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZLModelGoods;

@interface MZLHotGoodsCell : UITableViewCell

+ (CGFloat)cellHeigth;
- (void)updateWithGoods:(MZLModelGoods *)goods;

@end
