//
//  MZLAuthorHeader.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-29.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZLModelUser;

@interface MZLAuthorHeader : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imgAuthorHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthorName;
@property (weak, nonatomic) IBOutlet UILabel *lblAreas;
@property (weak, nonatomic) IBOutlet UILabel *lblDescriptions;

@property (weak, nonatomic) IBOutlet UIView *vwBottom;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthorArticleTitle;


- (void)initWithAuthorInfo:(MZLModelUser *)author;

@end