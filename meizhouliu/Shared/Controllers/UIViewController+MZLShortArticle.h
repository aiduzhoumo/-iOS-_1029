//
//  UIViewController+MZLShortArticle.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-30.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MZL_SHORT_ARTICLE_MAX_DISPLAY_PHOTO 9
#define MZL_SHORT_ARTICLE_PAGE_FETCH_COUNT 10
#define MZL_NOTIFICATION_SINGLE_SHORT_ARTICLE_UP_STATUS_MODIFIED @"MZL_NOTIFICATION_SINGLE_SHORT_ARTICLE_UP_STATUS_MODIFIED"
#define MZL_NOTIFICATION_SINGLE_SHORT_ARTICLE_COMMENT_STATUS_MODIFIED @"MZL_NOTIFICATION_SINGLE_SHORT_ARTICLE_COMMENT_STATUS_MODIFIED"


@class MZLModelShortArticle;

@interface UIViewController (MZLShortArticle)

- (void)mzl_loadSingleImageWithImageView:(UIImageView *)imageView fileUrl:(NSString *)fileUrl;
- (void)mzl_removeShortArticleAtIndexPath:(NSIndexPath *)indexPath;
- (void)mzl_toShortArticlePhotoGallery:(MZLModelShortArticle *)shortArticle;


+ (BOOL)mzl_shouldShowShareShortArticleModule;
+ (BOOL)mzl_shouldShowShareShortArticleModuleWithWeixin;
- (void)mzl_shareShortArticle:(MZLModelShortArticle *)shortArticle;
- (void)mzl_shareToWeixinWithShortArticle:(MZLModelShortArticle *)shortArticle;
- (void)mzl_onShareShortArticleSuccess;
- (void)mzl_onShareShortArticleFailure;

@end
