//
//  MZLModelFilterObject.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-2.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"
typedef NS_ENUM(NSInteger, MZLFilterItemType) {
    MZLFilterItemTypeLabel = 1,
    MZLFilterItemTypeImage  = 2,
};


@interface MZLModelFilterObject : MZLModelObject
@property (nonatomic , assign) NSInteger itemType;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, strong) NSString *imageName;

@end
