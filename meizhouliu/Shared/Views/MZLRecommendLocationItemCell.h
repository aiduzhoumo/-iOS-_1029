//
//  MZLRecommendLocationItemCell.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-28.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZLRecommendLocationItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblLocationName;

@property (weak, nonatomic) IBOutlet UIImageView *imgBg;
@property (weak, nonatomic) IBOutlet UIView *cellBg;
@property (weak, nonatomic) IBOutlet UIView *vwBg;
@property (weak, nonatomic) IBOutlet UILabel *lblLocationDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblArticleCount;
@property (weak, nonatomic) IBOutlet UILabel *lblArticleCountTip;

@end
