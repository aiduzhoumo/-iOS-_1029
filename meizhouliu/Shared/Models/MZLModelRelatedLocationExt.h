//
//  MZLModelDescendantInfo.h
//  mzl_mobile_ios
//
//  Created by race on 14/12/22.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"

#import "MZLModelImage.h"
#import "MZLModelLocationExt.h"

@interface MZLModelRelatedLocationExt : MZLModelObject

@property (nonatomic, strong) MZLModelImage *coverImg;
@property (nonatomic, strong) MZLModelLocationExt *locatinExt;
@end
