//
//  MZLNormalAuthorHeader.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-29.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLAuthorHeader.h"

@class MZLModelUser;

@interface MZLNormalAuthorHeader : MZLAuthorHeader

+ (id)normalAuthorHeader:(MZLModelUser *)author;

@end
