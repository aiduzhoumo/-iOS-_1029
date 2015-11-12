//
//  MZLModelUserPreference.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-17.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"

@interface MZLModelUserPreference : MZLModelObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) NSArray *favoriteArticles;
@property (nonatomic, strong) NSArray *interestedPlaces;

@end
