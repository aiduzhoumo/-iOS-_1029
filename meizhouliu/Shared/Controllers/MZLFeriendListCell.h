//
//  MZLFeriendListCell.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/7.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZLModelUser;
@interface MZLFeriendListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@property (weak, nonatomic) UIViewController *owenerController;

@property (nonatomic, weak) MZLModelUser *user;

- (void)initWithFeriendListInfo:(MZLModelUser *)user;

@end
