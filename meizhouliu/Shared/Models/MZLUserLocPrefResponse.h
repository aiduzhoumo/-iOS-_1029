//
//  MZLUserLocPrefResponse.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-24.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZLServiceResponseObject.h"

@class MZLModelUserLocationPref;

@interface MZLUserLocPrefResponse : MZLServiceResponseObject

@property (nonatomic, strong) MZLModelUserLocationPref *userLocationPref;
@property (nonatomic, strong) NSArray *userLocationPrefs;

@end
