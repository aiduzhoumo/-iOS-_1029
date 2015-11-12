//
//  MZLShortArticleCell.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-20.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLModelShortArticle.h"

typedef enum : NSInteger {
    MZLShortArticleCellTypeAuthor,
    MZLShortArticleCellTypeMy,
    MZLShortArticleCellTypeLocation,
    MZLShortArticleCellTypeDefault
} MZLShortArticleCellType;

#define MZLSAC_ReuseId1PhotoShortContent @"MZLSAC_ReuseId1PhotoShortContent"
#define MZLSAC_ReuseId9PhotoShortContent @"MZLSAC_ReuseId9PhotoShortContent"
#define MZLSAC_ReuseId1PhotoLongContent @"MZLSAC_ReuseId1PhotoLongContent"
#define MZLSAC_ReuseId9PhotoLongContent @"MZLSAC_ReuseId9PhotoLongContent"
//#define MZLSAC_EST_HEIGHT 526.0

@interface MZLShortArticleCell : UITableViewCell

@property (nonatomic, assign) MZLShortArticleCellType type;
@property (nonatomic, weak) UIViewController *ownerController;

//+ (instancetype)instanceFromType:(MZLShortArticleCellType)type model:(MZLModelShortArticle *)model tableView:(UITableView *)tableView;
+ (instancetype)cellWithTableview:(UITableView *)tableView type:(MZLShortArticleCellType)type model:(MZLModelShortArticle *)model;
//+ (CGFloat)heightFromType:(MZLShortArticleCellType)type model:(MZLModelShortArticle *)model;
+ (CGFloat)heightForTableView:(UITableView *)tableView withType:(MZLShortArticleCellType)type withModel:(MZLModelShortArticle *)model;


@end
