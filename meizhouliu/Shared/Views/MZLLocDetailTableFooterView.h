//
//  MZLLocDetailTableFooterView.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-6-5.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZLModelLocationDetail;

@interface MZLLocDetailTableFooterView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imgShareToWeixin;
@property (weak, nonatomic) IBOutlet UIImageView *imgLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;

+ (id)instance:(MZLModelLocationDetail *)locationDetail;

@end
