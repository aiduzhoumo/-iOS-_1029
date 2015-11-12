//
//  MZLTableViewFooterViewForSetting.h
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MZLSettingFooterViewHeight 80

@interface MZLTableViewFooterViewForSetting : UIView

@property (weak, nonatomic) IBOutlet UIView *vwEmpty;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (weak, nonatomic) IBOutlet UIView *vwLbl;

+ (id)footerViewInstance:(CGSize)parentViewSize;

@end
