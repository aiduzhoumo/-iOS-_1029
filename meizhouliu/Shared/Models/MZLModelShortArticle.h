//
//  MZLModelShortArticle.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-15.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"
#import "MZLModelSurroundingLocations.h"
#import "MZLModelImage.h"
#import "MZLModelUser.h"
#import "MZLModelShortArticleUp.h"

@interface MZLModelShortArticle : MZLModelObject

@property (nonatomic, strong) MZLModelSurroundingLocations *location;
@property (nonatomic, strong) MZLModelUser *author;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, readonly) NSArray *sortedPhotos;
@property (nonatomic, readonly) NSArray *sortedPhotosInViewMode;
@property (nonatomic, copy) NSString *tags;

@property (nonatomic, assign) NSInteger consumption;
@property (nonatomic, assign) double publishedAt;
@property (nonatomic, readonly) NSString *publishedAtStr;
@property (nonatomic, assign) NSInteger upsCount;
@property (nonatomic, assign) NSInteger commentsCount;
@property (nonatomic, readonly) NSInteger goodsCount;

/** 界面辅助字段，是否展开阅读，用于短文列表 */
@property (nonatomic, assign) BOOL isViewAll;
@property (nonatomic, readonly) BOOL needsGetUpStatusForCurrentUser;
/** 界面辅助字段，当前用户(可能匿名)是否已对短文点赞 */
@property (nonatomic, assign) BOOL isUpForCurrentUser;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat cellHeightUnderViewAll;

- (BOOL)arePhotosUploaded;
- (NSInteger)countOfUploadedPhotos;

/** used for sharing */
- (MZLModelImage *)firstPhoto;

@end
