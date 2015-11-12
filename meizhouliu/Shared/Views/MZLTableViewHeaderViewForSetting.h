//
//  MZLTableViewHeadViewForSetting.h
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZLTableViewHeaderViewForSetting : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgSex;
@property (weak, nonatomic) IBOutlet UILabel *lblNickName;

+ (id)headerViewInstance:(CGSize)parentViewSize;

@end
