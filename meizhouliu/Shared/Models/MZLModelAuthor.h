//
//  MZLModelAuthor.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"

@class MZLModelImage;

@interface MZLModelAuthor : MZLModelObject

@property(nonatomic, copy) NSString *name;
@property (nonatomic, strong) MZLModelImage *photo;

@property(nonatomic, readonly) NSString *photoUrl;
@property (nonatomic,copy) NSString *phone;

@property (nonatomic, assign) BOOL isAttention;
@end
