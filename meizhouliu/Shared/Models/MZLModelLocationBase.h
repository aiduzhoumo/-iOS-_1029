//
//  MZLModelLocationBase.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-25.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"

@class MZLModelImage, MZLModelLocationExt;

@interface MZLModelLocationBase : MZLModelObject

@property (nonatomic, assign) NSInteger identifier;

@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tagsStr;
@property (nonatomic, strong) MZLModelImage *coverImage;
@property (nonatomic, assign) NSInteger totalArticleCount;
@property (nonatomic, assign) NSInteger shortArticleCount;
@property (nonatomic, strong) MZLModelLocationExt *locationExt;
/** 是否风景区 */
@property (nonatomic, assign) BOOL isViewPoint;

@property(nonatomic, readonly) NSString *coverImageUrl;
@property(nonatomic, readonly) NSString *address;
@property(nonatomic, readonly) NSString *introduction;

@end
