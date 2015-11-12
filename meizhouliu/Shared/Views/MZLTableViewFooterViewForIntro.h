//
//  MZLTableViewFooterViewForIntro.h
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZLTableViewFooterViewForIntro : UIView
@property (weak, nonatomic) IBOutlet UIView *vwEmpty;
@property (weak, nonatomic) IBOutlet UIImageView *imgTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblIntro;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldIntro;

+ (id)footerViewInstance:(CGSize)parentViewSize;
@end
