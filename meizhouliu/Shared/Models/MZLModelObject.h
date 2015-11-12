//
//  MZLModelObject.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+CORestKitMapping.h"
#import "NSObject+CODictionaryParameter.h"

@interface MZLModelObject : NSObject<NSCoding, NSCopying>

@property (nonatomic, assign) NSInteger identifier;

@end
