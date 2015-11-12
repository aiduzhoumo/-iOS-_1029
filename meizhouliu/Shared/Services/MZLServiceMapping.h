//
//  MZLServiceMapping.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-16.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectMapping;

@interface MZLServiceMapping : NSObject

+ (RKObjectMapping *)articleObjectMapping;
+ (RKObjectMapping *)articleDetailObjectMapping;
+ (RKObjectMapping *)selectedArticleListResponseObjectMapping;

+ (RKObjectMapping *)authorObjectMapping;
+ (RKObjectMapping *)authorDetailObjectMapping;
+ (RKObjectMapping *)imageObjectMapping;

+ (RKObjectMapping *)locationBaseObjectMapping;
+ (RKObjectMapping *)locationObjectMapping;
+ (RKObjectMapping *)locationDetailObjectMapping;
+ (RKObjectMapping *)locationListResponseObjectMapping;

+ (RKObjectMapping *)userLocationPrefObjectMapping;
+ (RKObjectMapping *)userLocationPrefResponseObjectMapping;

+ (RKObjectMapping *)userFavoredArticleObjectMapping;
+ (RKObjectMapping *)userFavoredArticleResponseObjectMapping;

+ (RKObjectMapping *)tagTypeObjectMapping;

+ (RKObjectMapping *)serviceResponseObjectMapping;

+ (RKObjectMapping *)userRegLogInObjectMapping;

+ (RKObjectMapping *)userInfoObjectMapping;

+ (RKObjectMapping *)imageUploadResponseObjectMapping;

+ (RKObjectMapping *)dummyObjectMapping;

@end
