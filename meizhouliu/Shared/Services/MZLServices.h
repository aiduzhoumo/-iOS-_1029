//
//  MZLServices.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-15.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MZL_SVC_RESPONSE_HEADERS @"MZL_SVC_RESPONSE_EXT_HEADERS"

typedef void(^ MZL_SVC_SUCC_BLOCK)(NSArray *models);
typedef void(^ MZL_SVC_ERR_BLOCK)(NSError *error);

typedef void(^ MZL_SVC_REDIRECT_SUCC_BLOCK)(NSDictionary *models);
typedef void(^ MZL_SVC_REDIRECT_ERR_BLOCK)(NSError *error);

typedef void(^ MZL_SVC_SUCC_NULL_BLOCK)();

@class MZLArticleListSvcParam, MZLChildLocationsSvcParam, MZLPagingSvcParam, MZLModelArticle, MZLRegisterNormalSvcParam,MZLRegisterPhoneSvcParam,MZLRegisterSinaWeiboSvcParam, MZLRegisterTencentQqSvcParam, MZLLoginSvcParam, MZLModelUser, MZLModelUserInfoDetail, MZLModelUserLocationPref, MZLModelUserFavoredArticle, MZLModelComment, MZLModelNotice, MZLFilterParam, MZLModelImage, MZLModelLocation, MZLPersonalizeSvcParam, MZLDescendantsParam, MZLSurroundingLocSvcParam, MZLModelShortArticle, MZLModelShortArticleComment, MZLModelAuthor, MZLRegister3rdPartySvcParam, MZLRegisterBaseSvcParam, MZLModelSurroundingLocations, MZLGetCodeSvcParam, MZLVerifyCodeSvcParam, MZLPhoneLoginSvcParam, MZLImageUpLoadToUPaiYunResponse;


@interface MZLServices : NSObject

+ (NSString *)versionPlistUrl;

+ (void)registerByNormalService:(MZLRegisterNormalSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)registerByPhoneService:(MZLRegisterPhoneSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)registerBySinaWeiboService:(MZLRegisterSinaWeiboSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)registerByTencentQqService:(MZLRegisterTencentQqSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)registerByWeixinService:(MZLRegister3rdPartySvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)registerServiceWithType:(MZLLoginType)type param:(MZLRegisterBaseSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)loginByNormalService:(MZLLoginSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)loginByPhoneNumService:(MZLPhoneLoginSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)loginByWeiXinServiceWithOpenId:(NSString *)openId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)loginBySinaWeiboServiceWithOpenId:(NSString *)openId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)loginByTencentQqServiceWithOpenId:(NSString *)openId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)loginBy3rdPartyWithType:(MZLLoginType)type openId:(NSString *)openId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)logoutServiceWithAccesstoken:(NSString *)accessToken succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;

+ (id)locationArticleListServiceWithLocation:(MZLModelLocationBase *)location pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)locationArticleListServiceWithLocation:(MZLModelLocationBase *)location pagingParam:(MZLPagingSvcParam *)pagingParam filter:(MZLFilterParam *)filter succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)locationArticleListServiceWithLocationId:(NSNumber *)locationId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)locationArticleListService:(MZLArticleListSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)articleListServiceWithLocationName:(NSString *)locationName succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)articleListService:(MZLArticleListSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)systemArticleListService:(MZLArticleListSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)articleDetailService:(MZLModelArticle *)article succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)isArticleFavored:(MZLModelArticle *)article succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)favoredLocationsInArticle:(MZLModelArticle *)article succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;


+ (void)authorDetailService:(NSNumber *)authorId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)authorArticleListService:(NSNumber *)authorId pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;

+ (id)locationListServiceWithSuccBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)locationListServiceFromCurrentLocation:(NSString *)location succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)locationListServiceFromCurrentLocation:(NSString *)location pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)_locationDetailService:(NSInteger)locationId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)locationDetailService:(NSInteger)locationId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)childLocationsService:(MZLChildLocationsSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)locationPhotosService:(NSInteger)locationId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)locationPhotosService:(MZLModelLocationBase *)location pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)isLocationFavoredService:(MZLModelLocationBase *)location succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
//+ (id)locationGoodsService:(MZLModelLocationBase *)location pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)locationGoodsService:(MZLModelLocationBase *)location pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_REDIRECT_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_REDIRECT_ERR_BLOCK)errorBlock;

+ (id)favoredLocationsWithPagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)removeFavoredLocation:(MZLModelUserLocationPref *)favoredLocation succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)addLocationAsFavored:(NSInteger)locationId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;

+ (id)favoredArticlesWithPagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)removeFavoredArticle:(MZLModelUserFavoredArticle *)favoredArticle succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)addFavoredArticle:(NSInteger)articleId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;

+ (void)recordUserLocation:(NSString *)locationName;
+ (void)uploadUserImageService:(UIImage *)image succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)userInfoServiceWithSuccBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)modifyPasswordWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)bindPhoneWithToken:(NSString *)token phone:(NSString *)phone code:(NSString *)code succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)modifyUserInfo:(MZLModelUserInfoDetail *)user succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)modifyPasswordWithNewPassword:(NSString *)newPassword phone:(NSString *)phone code:(NSString *)code succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;

#pragma mark - comments related
+ (void)commentForArticle:(MZLModelArticle *)article pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)addComment:(MZLModelComment *)comment forArticle:(MZLModelArticle *)article succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)removeComment:(MZLModelComment *)comment forArticle:(MZLModelArticle *)article succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;

#pragma mark - notice related
+ (id)noticeFromLastDate:(NSDate *)date succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)noticeFromLocalWithsuccBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)removeNoticeFromLocal:(MZLModelNotice *)notice succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;

//+ (void)youmiActivationService;
//+ (void)youmengAdUrlService;

#pragma mark - 404 page URL

+ (NSString *)urlForCode404;

#pragma mark - configurations related

+ (void)checkSystemLocations;
+ (void)keywordsService;
//+ (void)cityListService;
//+ (void)systemLocationListService;
/** fetch all filters from service */
+ (void)filtersListService;
+ (void)tagsService;

#pragma mark - filter service

+ (id)filterArticlesServiceWithParam:(MZLFilterParam *)filterParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)filterLocationsServiceWithParam:(MZLFilterParam *)filterParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)filterLocationArticlesServiceOnLocation:(MZLModelLocation *)location param:(MZLFilterParam *)filterParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)filterChildLocationsService:(MZLChildLocationsSvcParam *)param param:(MZLFilterParam *)filterParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;

#pragma mark - personalize

+ (id)personalizeServiceWithParam:(MZLPersonalizeSvcParam *)param filter:(MZLFilterParam *)filter succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)cityPersonalizeServiceWithLocation:(NSString *)location filter:(MZLFilterParam *)filter succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)locationPersonalizeCoverServiceWithLocation:(MZLModelLocationBase *)location succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)locationPersonalizeDespServiceWithLocation:(MZLModelLocationBase *)location filter:(MZLFilterParam *)filter succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)locationPersonalizeServiceWithLocation:(MZLModelLocationBase *)location filter:(MZLFilterParam *)filter succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)locationPersonalizeTagDespServiceWithLocation:(MZLModelLocationBase *)location filter:(MZLFilterParam *)filter succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)relatedLocationPersonalizeService:(MZLChildLocationsSvcParam *)param param:(MZLFilterParam *)filterParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)relatedLocationPersonalizeExtService:(MZLModelLocationBase *)parentLocation param:(MZLDescendantsParam *)descendantsParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;


#pragma mark - author covers

+ (id)authorCoversServiceWithSuccBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)updateCoverWithCoverId:(NSInteger)identifier succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock ;

#pragma mark - goods related

+ (BOOL)hasGoodsFlagWithArticle:(MZLModelArticle *)arg1;
+ (void)goodsInArticle:(MZLModelArticle *)article succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
//+ (void)hotGoodsService:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)hotGoodsServiceWithLon:(CGFloat)lon lat:(CGFloat)lat succBlock:(MZL_SVC_REDIRECT_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_REDIRECT_ERR_BLOCK)errorBlock;

#pragma mark - short articles

+ (id)shortArticleDetailServiceWithId:(NSInteger)identifier succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)personalizeShortArticleServiceWithFilter:(MZLFilterParam *)filter pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)addUpForShortArticle:(MZLModelShortArticle *)shortArticle succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)removeUpForShortArticle:(MZLModelShortArticle *)shortArticle succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)upStatusForShortArticle:(MZLModelShortArticle *)shortArticle succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)addComment:(MZLModelShortArticleComment *)comment forShortArticle:(MZLModelShortArticle *)shortArticle succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
/** 短文回复评论 */
+ (void)replyComment:(MZLModelShortArticleComment *)comment forShortArticle:(MZLModelShortArticle *)shortArticle succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)removeComment:(MZLModelShortArticleComment *)comment forShortArticle:(MZLModelShortArticle *)shortArticle succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)commentsForShortArticle:(MZLModelShortArticle *)shortArticle pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)newCommentsForShortArticle:(MZLModelShortArticle *)shortArticle succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)authorShortArticleListWithAuthor:(MZLModelAuthor *)author pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)authorShortArticleListWithPagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)surroundingLocations:(MZLSurroundingLocSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (id)uploadPhoto:(UIImage *)image succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
/** 将图片名传给服务器获取UpaiYun的upyun_config及图片id */
+ (void)toGetupyun_configAndImageID:(UIImage *)image iamgeName:(NSString *)imageName succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
/** 上传图片UpaiYun */
+ (id)uploadPhotoToUPaiYun:(UIImage *)image imageName:(NSString *)imageName imageUpToUPaiYunResponse:(MZLImageUpLoadToUPaiYunResponse *)response succBlock:(MZL_SVC_SUCC_NULL_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock; 

+ (void)postShortArticleService:(MZLModelShortArticle *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)removeShortArticle:(MZLModelShortArticle *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
+ (void)shareShortArticleServiceWithId:(NSInteger)identifier;
/** 高德目的地查询 */
+ (void)aMapLocationQuery:(MZLModelSurroundingLocations *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
/** 高德目的地创建 */
+ (void)aMapLocationCreate:(MZLModelSurroundingLocations *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;

#pragma mark - data tracking

/** 启动时发送一条消息到服务端，方便统计 */
+ (void)heartbeatOnAppStartup;

#pragma mark - 友盟广告

+ (void)youmengAdUrlService;

/* 举报玩法 */
+ (void)reportForShortArticle:(MZLModelShortArticle *)shortArticle succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;

#pragma mark - user get code
+ (void)getSecCode:(MZLGetCodeSvcParam *)secCodeParams succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
#pragma mark - verify code
+ (void)verifyCode:(MZLVerifyCodeSvcParam *)secCodeParams succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;

#pragma mark - user forget password by email
+ (void)forgetPassWordByEmail:(NSString *)email succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;

#pragma mark - user register JPushID
+ (void)registerJpushWithUser;

#pragma mark - duzhoumoUserToken
+ (void)getDuzhoumoUserToken;

#pragma mark - attention
/** 关注了哪些人 */
+ (void)followDaRenListWithPagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
/** 对该用户的关注状态 */
+ (void)attentionStatesForCurrentUser:(MZLModelUser *)user succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
/** 对该用户添加关注 */
+ (void)addAttentionForShortArticleUser:(MZLModelUser *)user succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
/** 对该用户取消关注 */
+ (void)removeAttentionForShortArticleUser:(MZLModelUser *)user succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
/** 关注列表 */
+ (void)attentionListForUser:(MZLModelUser *)user WithPagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
/** 粉丝列表 */
+ (void)fensiListForUser:(MZLModelUser *)user WithPagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
/** 推荐达人列表 */
+ (void)tuijianDarenWithPagingParam:(MZLPagingSvcParam *)pagingParam SuccBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
/** 关注的文章列表 */
+ (id)followDarenShortArticleServiceWithFilter:(MZLFilterParam *)filter pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;
/** 筛选一些用户的关注情况 */
+ (void)fitterOfAttentionForUser:(NSString *)idArr SuccBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlobk:(MZL_SVC_ERR_BLOCK)errorBlock;
///** 查看他人粉丝列表 */
//+ (void)lookOtherUserFollowers:(MZLModelUser *)user SuccBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlobk:(MZL_SVC_ERR_BLOCK)errorBlock;
///** 查看他人关注列表 */
//+ (void)lookOtherUserFollowees:(MZLModelUser *)user SuccBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlobk:(MZL_SVC_ERR_BLOCK)errorBlock;
#pragma mark - modifyUserName
/** 修改用户昵称 */
+ (void)modifyUserName:(MZLModelUserInfoDetail *)user WithNewName:(NSString *)newName SuccBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock;


@end
