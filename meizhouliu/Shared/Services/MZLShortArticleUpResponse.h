//
//  MZLShortArticleUpResponse.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-29.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLServiceResponseObject.h"
#import "MZLModelShortArticleUp.h"

@interface MZLShortArticleUpResponse : MZLServiceResponseObject

@property (nonatomic, strong) MZLModelShortArticleUp *up;

@end
