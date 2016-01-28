//
//  MZLTuiJianDarenCell.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/12/31.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZLTuiJianDarenCellShowOrHideNetworkProgressIndicatorDelegate <NSObject>
- (void)showNetworkProgressIndicatorOnTuijianVc;
- (void)hideNetworkProgressIndicatorOnTuijianVc:(BOOL)isSuccess;
@end

@class MZLModelUser;
@interface MZLTuiJianDarenCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imageOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imageThree;

@property (nonatomic, weak) id<MZLTuiJianDarenCellShowOrHideNetworkProgressIndicatorDelegate> delegate;
@property (nonatomic, strong) MZLModelUser *user;

- (void)initWithInfo:(MZLModelUser *)user;
@end
