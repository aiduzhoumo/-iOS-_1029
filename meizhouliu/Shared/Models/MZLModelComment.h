//
//  MZLModelComment.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-25.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"
#import "MZLModelUser.h"

@interface MZLModelComment : MZLModelObject 

@property (nonatomic, strong) MZLModelUser *user;
@property (nonatomic, copy) NSString *content;

@end
