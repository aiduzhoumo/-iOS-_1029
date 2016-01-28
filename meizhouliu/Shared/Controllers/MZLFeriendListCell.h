//
//  MZLFeriendListCell.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/7.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MZLModelUser;

@protocol MZLFeriendListCellShowOrHideNetworkProgressIndicatorDelegate <NSObject>
- (void)showNetworkProgressIndicatorOnFeriendVC;
- (void)hideNetworkProgressIndicatorOnFeriendVC:(BOOL)isSuccess;
@end

@interface MZLFeriendListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@property (weak, nonatomic) UIViewController *owenerController;

@property (nonatomic, weak) MZLModelUser *user;

@property (nonatomic, weak) id<MZLFeriendListCellShowOrHideNetworkProgressIndicatorDelegate> delegate;
- (void)initWithFeriendListInfo:(MZLModelUser *)user;

@end
