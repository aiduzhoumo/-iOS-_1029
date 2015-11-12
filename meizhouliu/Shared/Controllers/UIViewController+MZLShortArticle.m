//
//  UIViewController+MZLShortArticle.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-30.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "UIViewController+MZLShortArticle.h"
#import "UIImage+COAdditions.h"
#import "UIImageView+MZLNetwork.h"
#import "MZLModelShortArticle.h"
#import "MZLImageGalleryNavigationController.h"
#import "MZLShortArticleGalleryVC.h"
#import <IBAlertView.h>
#import "NSString+MZLImageURL.h"

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApi.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "MZLServices.h"

@implementation UIViewController (MZLShortArticle)

- (void)mzl_removeShortArticleAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)mzl_loadSingleImageWithImageView:(UIImageView *)imageView fileUrl:(NSString *)fileUrl {
    block_co_handle_image_data block = ^ UIImage * (NSData *imageData) {
        UIImage *image = [UIImage imageWithData:imageData];
        CGFloat height = 230;
        // 模板取得是 540 * 366
        CGFloat width = 230 * 540 / 366;
        image = [image scaledToSize:CGSizeMake(width, height)];
        return image;
    };
    block_co_set_image_placeholder setPlaceHolder = ^ (UIImage *placeholder, UIImageView *imageView) {
        UIImage *image = [placeholder scaledToSize:CGSizeMake(294, 230)];
        imageView.image = image;
    };
    NSDictionary *contextInfo = @{
                                  KEY_CO_HANDLE_IMAGE_DATA : block,
                                  KEY_CO_IMAGE_SET_PLACEHOLDER : setPlaceHolder
                                  };
    [imageView load_540_366_ImageFromURL:fileUrl contextInfo:contextInfo];
}

- (void)mzl_toShortArticlePhotoGallery:(MZLModelShortArticle *)shortArticle {
    MZLImageGalleryNavigationController *navController = [[MZLImageGalleryNavigationController alloc] init];
    MZLShortArticleGalleryVC *vcGallery = [[MZLShortArticleGalleryVC alloc] init];
    NSArray *photos = shortArticle.sortedPhotosInViewMode;
    if (photos.count > MZL_SHORT_ARTICLE_MAX_DISPLAY_PHOTO) {
        photos = [photos subarrayWithRange:NSMakeRange(0, MZL_SHORT_ARTICLE_MAX_DISPLAY_PHOTO)];
    }
    vcGallery.photos = photos;
    [navController pushViewController:vcGallery animated:NO];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - share

#define SHARE_SHORT_ARTICLE_ALLTYPES 0x111
#define SHARE_SHORT_ARTICLE_TYPE_WEIBO 0x001
#define SHARE_SHORT_ARTICLE_TYPE_QQ 0x010
#define SHARE_SHORT_ARTICLE_TYPE_WEIXIN 0x100

+ (BOOL)mzl_shouldShowShareShortArticleModule {
    return [self mzl_shouldShowShareShortArticleModuleWithType:SHARE_SHORT_ARTICLE_ALLTYPES];
}

+ (BOOL)mzl_shouldShowShareShortArticleModuleWithWeixin {
    return [self mzl_shouldShowShareShortArticleModuleWithType:SHARE_SHORT_ARTICLE_TYPE_WEIXIN];
}


/*
 *  检查用户是否已安装qq/weixin/sina
 */
+ (BOOL)mzl_shouldShowShareShortArticleModuleWithType:(NSInteger)type {
    if ( ([WeiboSDK isWeiboAppInstalled] && (type & SHARE_SHORT_ARTICLE_TYPE_WEIBO) > 0) ||
        ([QQApi isQQInstalled] && (type & SHARE_SHORT_ARTICLE_TYPE_QQ) > 0) ||
        ([WXApi isWXAppInstalled] && (type & SHARE_SHORT_ARTICLE_TYPE_WEIXIN) > 0) )
    {
        return YES;
    }
    return NO;
}

- (void)mzl_shareShortArticle:(MZLModelShortArticle *)shortArticle {
    [self mzl_shareShortArticle:shortArticle shareType:SHARE_SHORT_ARTICLE_ALLTYPES];
}

- (void)mzl_shareToWeixinWithShortArticle:(MZLModelShortArticle *)shortArticle {
    [self mzl_shareShortArticle:shortArticle shareType:SHARE_SHORT_ARTICLE_TYPE_WEIXIN];
}

- (void)mzl_shareShortArticle:(MZLModelShortArticle *)shortArticle shareType:(NSInteger)shareType {
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    
    NSString *articleTitle = [[NSString alloc] init];
    if ([MZLSharedData appUserId] == shortArticle.author.identifier) {
        articleTitle = @"我去了【%@】，刚晒了美照，还不帮我点赞去~";
    } else {
        articleTitle = @"我觉得【%@】还蛮赞的，下次一起去吧";
    }
    articleTitle = [NSString stringWithFormat:articleTitle, shortArticle.location.locationName];
    
    NSString *articleContent = @"";
    if (! isEmptyString(shortArticle.content)) {
        NSInteger wordLimit = 26;
        if (shortArticle.content.length <= wordLimit) {
            articleContent = shortArticle.content;
        } else {
            articleContent = [shortArticle.content substringToIndex:wordLimit];
            articleContent = [NSString stringWithFormat:@"%@...", articleContent];
        }
    }
    
    NSString *imageURL = [shortArticle.firstPhoto.fileUrl imageUrl_210_210];
    NSString *articleURL = [NSString stringWithFormat:@"%@%@",@"http://www.meizhouliu.com/short_articles/", @(shortArticle.identifier)];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:articleContent
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:imageURL]
                                                title:articleTitle
                                                  url:articleURL
                                          description:articleContent
                                            mediaType:SSPublishContentMediaTypeNews];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:nil
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:NO
                                                        wxSessionButtonHidden:NO
                                                       wxTimelineButtonHidden:NO
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:nil
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    NSArray *shareList = [NSArray array];
    if ([WXApi isWXAppInstalled] && (shareType & SHARE_SHORT_ARTICLE_TYPE_WEIXIN) > 0) {
        NSArray *wxShareList = [ShareSDK customShareListWithType:
                                SHARE_TYPE_NUMBER(ShareTypeWeixiFav),
                                SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                                SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline), nil];
        shareList = [shareList arrayByAddingObjectsFromArray:wxShareList];
    }
    if ([WeiboSDK isWeiboAppInstalled] && (shareType & SHARE_SHORT_ARTICLE_TYPE_WEIBO) > 0) {
        // 新浪微博分享内容需要定制
        id<ISSShareActionSheetItem> item = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
                                                                              icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                                                                      clickHandler:^{
                                                                          // 微博不区分title和content，直接用title替代原来的content
                                                                          [publishContent setContent:articleTitle];
                                                                          [ShareSDK clientShareContent:publishContent
                                                                                                  type:ShareTypeSinaWeibo
                                                                                         statusBarTips:YES
                                                                                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                                    [self mzl_onShareShortArticleResultWithType:type state:state statusInfo:statusInfo error:error end:end shortArticle:shortArticle];
                                                                                                }];
                                                                      }];
        NSArray *weiboShareList = [ShareSDK customShareListWithType:item, nil];
        //        NSArray *weiboShareList = [ShareSDK customShareListWithType:SHARE_TYPE_NUMBER(ShareTypeSinaWeibo), nil];
        shareList = [shareList arrayByAddingObjectsFromArray:weiboShareList];
    }
    if ([QQApi isQQInstalled] && (shareType & SHARE_SHORT_ARTICLE_TYPE_QQ) > 0) {
        NSArray *qqShareList = [ShareSDK customShareListWithType:
                                SHARE_TYPE_NUMBER(ShareTypeQQ),
                                SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                                nil];
        shareList = [shareList arrayByAddingObjectsFromArray:qqShareList];
    }
    if (shareList.count == 0) {
        return;
    }
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                [self mzl_onShareShortArticleResultWithType:type state:state statusInfo:statusInfo error:error end:end shortArticle:shortArticle];
                            }];
}

- (void)mzl_onShareShortArticleResultWithType:(ShareType)type state:(SSResponseState)state statusInfo:(id<ISSPlatformShareInfo>)statusInfo error:(id<ICMErrorInfo>)error end:(BOOL)end shortArticle:(MZLModelShortArticle *)shortArticle {
    if (state == SSResponseStateFail) {
        // NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
        NSString *errorDesp = [error errorDescription];
        NSInteger errorCode = [error errorCode];
        if (isEmptyString(errorDesp) || errorCode == 0) {
            return;
        }
        NSString *errorReason = [NSString stringWithFormat:@"分享失败：%@（错误码:%@）", errorDesp, @(errorCode)];
        [IBAlertView alertWithTitle:MZL_MSG_ALERT_VIEW_TITLE message:errorReason dismissTitle:MZL_MSG_OK dismissBlock:^{
            [self mzl_onShareShortArticleFailure];
        }];
    } else if (state != SSResponseStateBegan) {
        [MZLServices shareShortArticleServiceWithId:shortArticle.identifier];
        [self mzl_onShareShortArticleSuccess];
    }
}

- (void)mzl_onShareShortArticleSuccess {}

- (void)mzl_onShareShortArticleFailure {}

@end
