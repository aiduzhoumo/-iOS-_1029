//
//  MZLModelLocationDesp.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-26.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZLModelObject.h"
#import "MZLModelUser.h"

@interface MZLModelLocationDesp : MZLModelObject

@property (nonatomic, strong) MZLModelUser *user;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, readonly) NSString *userName;
@property (nonatomic, readonly) NSString *userImageUrl;

@end
