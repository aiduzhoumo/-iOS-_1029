//
//  MZLSignedAuthorHeader.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-29.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLAuthorHeader.h"

@class MZLModelUser;

@interface MZLSignedAuthorHeader : MZLAuthorHeader

@property (weak, nonatomic) IBOutlet UIView *vwBg;
@property (weak, nonatomic) IBOutlet UIImageView *imgCover;


+ (id)signedAuthorHeader:(MZLModelUser *)author;

@end
