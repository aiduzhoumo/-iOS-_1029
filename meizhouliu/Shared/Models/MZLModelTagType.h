 //
//  MZLModelTagType.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-6-6.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"

#define MZL_TAG_TYPE_CROWD 2
#define MZL_TAG_TYPE_FEATURE 3

@interface MZLModelTagType : MZLModelObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tags;

@property (nonatomic, strong) NSArray *tagsArray;

+ (instancetype)tagTypeWithName:(NSString *)name tagsStrArray:(NSArray *)tagsStrArray;

+ (void)saveInPreference:(NSArray *)tagTypes;
+ (NSArray *)cachedTagTypes;

@end
