//
//  MZLShortArticleCellStyle2.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15/3/27.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLShortArticleCellBase.h"

@class MZLModelShortArticle;

@interface MZLShortArticleCellStyle2 : MZLShortArticleCellBase

+ (instancetype)cellWithTableview:(UITableView *)tableView model:(MZLModelShortArticle *)model;
+ (CGFloat)heightForTableView:(UITableView *)tableView withModel:(MZLModelShortArticle *)model;


@end
