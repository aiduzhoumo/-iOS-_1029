//
//  MZLServices.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-15.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLServices.h"
#import "RestKit/RestKit.h"
#import "MZLServiceMapping.h"
#import "MZLArticleListSvcParam.h"
#import "MZLChildLocationsSvcParam.h"
#import "MZLPagingSvcParam.h"
#import "MZLModelArticle.h"
#import "COPreferences.h"
#import "MobClick.h"
#import "MZLServiceResponseObject.h"
#import "MZLRegisterNormalSvcParam.h"
#import "MZLRegisterSinaWeiboSvcParam.h"
#import "MZLRegisterTencentQqSvcParam.h"
#import "MZLLoginSvcParam.h"
#import "MZLAppUser.h"
#import "MZLModelUser.h"
#import "MZLModelUserInfoDetail.h"
#import "MZLModelUserLocationPref.h"
#import "MZLModelUserFavoredArticle.h"
#import "MZLModelComment.h"
#import "MZLCommentResponse.h"
#import "NSError+CONetwork.h"
#import "MZLModelNotice.h"
#import "MZLModelFilterType.h"
#import "MZLFilterParam.h"
#import "MZLSharedData.h"
#import "MZLAppNotices.h"
#import "MZLModelSystemLocation.h"
#import "MZLSysLocationLocalStore.h"
#import <IBMessageCenter.h>
#import "MZLModelLocation.h"
#import "MZLModelGoodsDetail.h"
#import "MZLModelTagDesp.h"
#import "MZLPersonalizeSvcParam.h"
#import "MZLDescendantsParam.h"
#import "MZLModelRelatedLocation.h"
#import "MZLModelRelatedLocationExt.h"
#import "Reachability.h"
#import "MZLServiceOperation.h"
#import "MZLSurroundingLocSvcParam.h"
#import "MZLModelSurroundingLocations.h"
#import "MZLModelShortArticle.h"
#import "MZLShortArticleResponse.h"
#import "MZLModelLocationDesp.h"
#import "MZLShortArticleUpResponse.h"
#import "MZLModelShortArticleComment.h"
#import "MZLShortArticleCommentResponse.h"
#import "MZLModelAuthor.h"
#import "MZLModelTagType.h"
#import "MZLServiceConsts.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import "MZLAMapSearchDelegateForService.h"
#import "MZLLocResponse.h"

#define MZL_SERVICE_REGISTER @"users/register"
#define MZL_SERVICE_REGISTER_SINA_WEIBO @"users/register/weibo"
#define MZL_SERVICE_REGISTER_TENCENT_QQ @"users/register/qq"
#define MZL_SERVICE_REGISTER_WEIXIN @"users/register/wechat"
#define MZL_SERVICE_LOGIN @"login"
#define MZL_SERVICE_SINA_WEIBO_LOGIN @"login/weibo"
#define MZL_SERVICE_TENCENT_QQ_LOGIN @"login/qq"
#define MZL_SERVICE_WEIXIN_LOGIN @"login/wechat"
#define MZL_SERVICE_LOGOUT @"logout"
#define MZL_SERVICE_USER_INFO @"users/%d"
#define MZL_SERVICE_MODIFY_USER_INFO @"users/%d"
#define MZL_SERVICE_MODIFY_USER_PASSWORD @"users/%d/password"
#define MZL_SERVICE_USER_UPLOAD_IMAGE @"users/%d/photo"

#define MZL_SERVICE_ARTICLES @"articles"
#define MZL_SERVICE_SYSTEM_ARTICLES @"articles/choice"
#define MZL_SERVICE_LOCATION_ARTICLES @"new_destinations/%d/articles"
#define MZL_SERVICE_ARTICLE_DETAIL @"articles/%d"
#define MZL_SERVICE_IS_ARTICLE_FAVORED_BY_USER @"articles/%d/favorite"
#define MZL_SERVICE_FAVORED_LOCATIONS_IN_ARTICLE @"articles/%d/wants"

#define MZL_SERVICE_ARTICLE_COMMENT @"articles/%d/comments"
#define MZL_SERVICE_ARTICLE_ADD_COMMENT MZL_SERVICE_ARTICLE_COMMENT
#define MZL_SERVICE_ARTICLE_REMOVE_COMMENT @"articles/%d/comments/%d"

#define MZL_SERVICE_NOTICES @"notices"
#define MZL_SERVICE_REMOVE_NOTICES @"notices/%d"

#define MZL_SERVICE_ARTICLE_GOODS @"articles/%d/products"
#define MZL_SERVICE_ARTICLE_GOODS_FLAG @"articles/%@/products/exist"
#define MZL_SERVICE_HOT_PRODUCTS @"products/hot"
#define MZL_SERVICE_LOCATION_HOT_PRODUCTS @"destinations/hot_products"

#define MZL_SERVICE_LOCATIONS @"new_destinations/recommend"
#define MZL_SERVICE_LOCATIONDETAIL @"destinations/%d"
//#define MZL_SERVICE_LOCATIONDETAIL_NEW @"new_destinations/%d"
#define MZL_SERVICE_CHILDLOCATIONS @"new_destinations/%d/descendants"
#define MZL_SERVICE_LOCATIONS_DEFAULT @"new_destinations/recommend/default"
//#define MZL_SERVICE_LOCATION_ALLPHOTOS @"new_destinations/%d/photos"
#define MZL_SERVICE_LOCATION_PHOTOS @"new_destinations/%d/photos"
#define MZL_SERVICE_LOCATION_IS_FAVORED @"new_destinations/%d/want"
#define MZL_SERVICE_LOCATION_GOODS @"destinations/%d/products"
#define MZL_SERVICE_LOCATION_SHORT_ARTICLES @"destinations/%d/short_articles"

#define MZL_SERVICE_AUTHORDETAIL @"authors/%d"
#define MZL_SERVICE_AUTHOR_ARTICLES @"authors/%d/articles"

#define MZL_SERVICE_GETFAVOREDLOCATIONS @"wants"
#define MZL_SERVICE_ADDFAVOREDLOCATION @"wants"
#define MZL_SERVICE_REMOVEFAVOREDLOCATION @"wants/%d"

#define MZL_SERVICE_GETFAVOREDARTICLES @"favorites"
#define MZL_SERVICE_ADDFAVOREDARTICLE @"favorites"
#define MZL_SERVICE_REMOVEFAVOREDARTICLE @"favorites/%d"

#define MZL_SERVICE_CITYLIST @"configs/city"
#define MZL_SERVICE_KEYWORDS @"configs/keyword"
#define MZL_SERVICE_SYSTEMLOCATIONLIST @"configs/administratives"
#define MZL_SERVICE_FILTERLIST @"configs/filters"
#define MZL_SERVICE_TAGS @"tags/default"

#define MZL_SERVICE_PLIST_VERSION @"version/versions"

#define MZL_SERVICE_YOUMI_ACTIVATION @"channels"

#define MZL_SERVICE_RECORD_USER_LOCATION @"devices"

#define MZL_SERVICE_FILTER_ARTICLES @"screen/articles/choice"
#define MZL_SERVICE_FILTER_LOCATIONS @"screen/destinations"
#define MZL_SERVICE_FILTER_LOCATION_ARTICLES @"screen/destinations/%d/articles"
#define MZL_SERVICE_FILTER_CHILD_LOCATIONS @"screen/destinations/%d/descendants"

#define MZL_SERVICE_AUTHOR_COVERS @"authors/covers"
#define MZL_SERVICE_UPDATE_COVER @"authors/cover"

#define MZL_SERVICE_APP_HEARTBEAT @"users/open_app"

#define MZL_SERVICE_UPLOAD_PHOTO @"photos"

#define MZL_SERVICE_PERSONALIZE @"personalize"
#define MZL_SERVICE_PERSONALIZE_CITIES @"personalize/cities"
#define MZL_SERVICE_PERSONALIZE_LOCATION @"personalize/destinations/%d"
#define MZL_SERVICE_PERSONALIZE_LOCATION_COVER @"personalize/destinations/%d/cover"
#define MZL_SERVICE_PERSONALIZE_LOCATION_DESP @"personalize/destinations/%d/description"
#define MZL_SERVICE_PERSONALIZE_LOCATION_TAG_DESP @"personalize/destinations/%@/tags"
#define MZL_SERVICE_PERSONALIZE_CHILD_LOCATIONS_DESCENDANTS @"destinations/%d/relate_destinations"
#define MZL_SERVICE_PERSONALIZE_CHILD_LOCATIONS_DESCENDANTS_INFO @"destinations/%d/relate_destinations/info"

#define MZL_SERVICE_SHORTARTICLE_SURROUNDING_LOCTIONS @"location/nearby"
#define MZL_SERVICE_PERSONALIZE_SHORT_ARTICLE @"short_articles"
#define MZL_SERVICE_SHORT_ARTICLE_DETAIL @"short_articles/%d"
#define MZL_SERVICE_SHORT_ARTICLE_ADD @"short_articles"
#define MZL_SERVICE_SHORT_ARTICLE_REMOVE @"short_articles/%d"
#define MZL_SERVICE_SHORT_ARTICLE_LIST_OWN @"short_articles/own"
#define MZL_SERVICE_SHORT_ARTICLE_LIST_AUTHOR @"users/%d/short_articles"
#define MZL_SERVICE_SHORT_ARTICLE_GETUP @"short_articles/%d/ups/status"
#define MZL_SERVICE_SHORT_ARTICLE_ADDUP @"short_articles/%d/ups"
#define MZL_SERVICE_SHORT_ARTICLE_REMOVEUP @"short_articles/%d/ups"
#define MZL_SERVICE_SHORT_ARTICLE_GETCOMMENTS @"short_articles/%d/comments"
#define MZL_SERVICE_SHORT_ARTICLE_ADDCOMMENT @"short_articles/%d/comments"
#define MZL_SERVICE_SHORT_ARTICLE_REMOVECOMMENT @"short_articles/%d/comments/%d"
#define MZL_SERVICE_SHORT_ARTICLE_SHARE @"short_articles/%d/shares"
#define MZL_SERVICE_AMAP_LOCATION_QUERY @"amap/%@"
#define MZL_SERVICE_AMAP_LOCATION_CREATE @"amap"

#define MZL_SERVICE_SHORT_ARTICLE_REPORT @"short_articles/%d/reports"

#define MZL_SERVICE_TIMER_KEY_TIMER @"MZL_SERVICE_TIMER_KEY_TIMER"
#define MZL_SERVICE_TIMER_KEY_ERROR_BLOCK @"MZL_SERVICE_TIMER_KEY_ERROR_BLOCK"
#define MZL_SERVICE_TIMER_KEY_TIMEOUT @"MZL_SERVICE_TIMER_KEY_TIMEOUT"

#define MZL_SERVICE_ERROR_DOMAIN_TIMEOUT @"com.meizhouliu.error.timeout"

#define MZL_SERVICE_PARAM_KEY_DESTINATION_NAME @"destination_name"
#define MZL_SERVICE_PARAM_KEY_SHORT_ARTICLE @"short_article"

//@interface MZLServiceOperation : NSOperation
//
//@property (nonatomic, strong) NSOperation *internalOper;
//
//@end
//
//@implementation MZLServiceOperation
//
//- (BOOL)isFinished {
//    return [self.internalOper isFinished];
//}
//
//- (void)cancel {
//    return [self.internalOper cancel];
//}
//
//@end


@interface RKObjectRequestOperation (MZLServiceTimer)

@end

@implementation RKObjectRequestOperation (MZLServiceTimer)

- (NSTimer *)addTimeoutTimerWithBlock:(MZL_SVC_ERR_BLOCK)errorBlock  {
    NSDictionary *userInfo = @{
                               MZL_SERVICE_TIMER_KEY_ERROR_BLOCK : errorBlock
                               };
    NSNumber *timeoutObj = [self getProperty:MZL_SERVICE_TIMER_KEY_TIMEOUT];
    NSTimeInterval timeout = timeoutObj ? [timeoutObj doubleValue] : MZL_DEFAULT_TIMEOUT;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(onServiceTimer:) userInfo:userInfo repeats:NO];
    [self setProperty:MZL_SERVICE_TIMER_KEY_TIMER value:timer];
    return timer;
}

- (void)cancelTimeoutTimer {
    NSTimer *timer = [self getProperty:MZL_SERVICE_TIMER_KEY_TIMER];
    if (timer) {
        [timer invalidate];
    }
}

- (void)onServiceTimer:(NSTimer *)timer {
    NSDictionary *userInfo = [timer userInfo];
    if (! [self isFinished]) {
        [self cancel];
        MZL_SVC_ERR_BLOCK errorBlock = userInfo[MZL_SERVICE_TIMER_KEY_ERROR_BLOCK];
        if (errorBlock) {
            NSError *error = [NSError errorWithDomain:MZL_SERVICE_ERROR_DOMAIN_TIMEOUT code:MZL_ERROR_CODE_TIMEOUT userInfo:nil];
            errorBlock(error);
        }
    }
}

@end

@implementation MZLServices

#pragma mark - initialize

+ (void)initialize {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

#pragma mark - common

+ (NSString *)versionPlistUrl {
    return [NSString stringWithFormat:@"%@/%@.plist", MZL_SERVICE_BASE_URL, MZL_SERVICE_PLIST_VERSION];
}

+ (NSString *)serviceUrlWithName:(NSString *)name version:(NSString *)version {
    return [NSString stringWithFormat:@"%@/%@.json", version, name];
}

+ (NSString *)servicePath:(NSString *)name {
    return [self serviceUrlWithName:name version:MZL_SERVICE_VERSION_V1];
}

+ (NSString *)serviceUrl_v2:(NSString *)name {
    return [self serviceUrlWithName:name version:MZL_SERVICE_VERSION_V2];
}

+ (NSString *)serviceUrl_v1:(NSString *)name {
    return [self serviceUrlWithName:name version:MZL_SERVICE_VERSION_V1];
}

+ (NSString *)servicePath:(NSString *)serviceName integerParam:(NSInteger)param {
    NSString *path = [self servicePath:serviceName];
    path = [NSString stringWithFormat:path, param];
    return path;
}

+ (NSString *)servicePath:(NSString *)serviceName numberParam:(NSNumber *)param {
    NSString *path = [self servicePath:serviceName];
    path = [NSString stringWithFormat:path, param];
    return path;
}

+ (NSString *)servicePath:(NSString *)serviceName integerParam1:(NSInteger)param1 integerParam2:(NSInteger)param2 {
    NSString *path = [self servicePath:serviceName];
    path = [NSString stringWithFormat:path, param1, param2];
    return path;
}

+ (void)addErrorMappingForObjectManager:(RKObjectManager *)objectManager {
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[MZLServiceMapping dummyObjectMapping] method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)]];
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[MZLServiceMapping dummyObjectMapping] method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassServerError)]];
}

+ (RKObjectManager *)objectManager {
    RKObjectManager *result = [self objectManager:MZL_SERVICE_BASE_URL];
    [self addErrorMappingForObjectManager:result];
    return result;
}

+ (RKObjectManager *)objectManagerDev {
    return [self objectManager:MZL_SERVICE_DEV_URL];
}

+ (RKObjectManager *)objectManagerTest {
    return [self objectManager:MZL_SERVICE_TEST_URL];
}

+ (RKObjectManager *)objectManagerPhoto {
    return [self objectManager:MZL_SERVICE_PHOTO_URL];
}

+ (RKObjectManager *)objectManager:(NSString *)baseURL {
    RKObjectManager *result = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:baseURL]];
    return result;
}

+ (RKResponseDescriptor *)responseDescriptor:(RKObjectMapping *)objectMapping servicePath:(NSString *)servicePath {
    return [self responseDescriptor:objectMapping servicePath:servicePath keyPath:nil];
}

+ (RKResponseDescriptor *)responseDescriptor:(RKObjectMapping *)objectMapping servicePath:(NSString *)servicePath keyPath:(NSString *)keyPath {
    return [RKResponseDescriptor responseDescriptorWithMapping:objectMapping method:RKRequestMethodAny pathPattern:servicePath keyPath:keyPath statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

+ (void)objectManager:(RKObjectManager *)objectManager addResponseDescriptorFromMapping:(RKObjectMapping *)objectMapping servicePath:(NSString *)servicePath {
    [objectManager addResponseDescriptor:[self responseDescriptor:objectMapping servicePath:servicePath]];
}

+ (void)objectManager:(RKObjectManager *)objectManager addResponseDescriptorFromMapping:(RKObjectMapping *)objectMapping {
    [self objectManager:objectManager addResponseDescriptorFromMapping:objectMapping servicePath:nil];
}


+ (void)objectManager:(RKObjectManager *)objectManager addDummyResponseDescriptorOnSuccCodesForServicePath:(NSString *)servicePath {
    // if we've already defined the descriptor for successCodes, skip this
    for (RKResponseDescriptor *responseDescriptor in objectManager.responseDescriptors) {
        if ([RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful) isEqualToIndexSet:responseDescriptor.statusCodes]) {
            return;
        }
    }
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:[MZLServiceMapping dummyObjectMapping] method:RKRequestMethodAny pathPattern:servicePath keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
}

#pragma mark - common for get, post etc. operations

+ (RKObjectRequestOperation *)lastOperationFromObjectManager:(RKObjectManager *)objectManager {
    NSOperationQueue *queue = objectManager.operationQueue;
    return queue.operations[queue.operations.count - 1];
}

+ (BOOL)shouldIgnoreError:(NSError *)error {
    return error && [error code] == MZL_ERROR_CODE_CANCLED;
}

+ (RKObjectRequestOperation *)addTimeoutTimerOnLastOperationForObjectManager:(RKObjectManager *)objectManager errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectRequestOperation * operation = [self lastOperationFromObjectManager:objectManager];
    NSNumber *timeoutObj = [objectManager getProperty:MZL_SERVICE_TIMER_KEY_TIMEOUT];
    if (timeoutObj) {
        [operation setProperty:MZL_SERVICE_TIMER_KEY_TIMEOUT value:timeoutObj];
    }
    [operation addTimeoutTimerWithBlock:errorBlock];

    return operation;
}

+ (void)onServiceError:(NSError *)error operation:(RKObjectRequestOperation *)operation errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock  {
    [self onServiceError:error operation:operation succBlock:nil errorBlock:errorBlock ignoreStatusCodes:nil];
}

+ (void)onServiceError:(NSError *)error operation:(RKObjectRequestOperation *)operation succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock ignoreStatusCodes:(NSArray *)statusCodes {
    [operation cancelTimeoutTimer];
    if ([self shouldIgnoreError:error]) {
        NSLog(@"MZLService getObjects: ignore cancelled error");
        return;
    }
    NSInteger responseStatusCode = operation.HTTPRequestOperation.response.statusCode;
    if (statusCodes) {
        for (NSNumber *statusCode in statusCodes) {
            if (responseStatusCode == [statusCode integerValue]) {
                succBlock(nil);
                return;
            }
        }
    }
    [error co_setResponseStatusCode:responseStatusCode];
    // token过期，直接logout
    if (responseStatusCode == MZL_HTTP_RESPONSECODE_AUTH_FAILURE) {
        [MZLSharedData logout];
    }
    errorBlock(error);
}

+ (void)onServiceSuccessWithCode:(NSInteger)succStatusCode operation:(RKObjectRequestOperation *)operation mappping:(RKMappingResult *)mapping succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    [operation cancelTimeoutTimer];
    if (operation.HTTPRequestOperation.response.statusCode == succStatusCode) {
        NSArray *mappingArray = [mapping array];
        NSDictionary *responseHeaders = operation.HTTPRequestOperation.response.allHeaderFields;
        if (responseHeaders) {
            [mappingArray setProperty:MZL_SVC_RESPONSE_HEADERS value:responseHeaders];
        }
        succBlock(mappingArray);
    } else {
        errorBlock(nil);
    }
}

+ (NSDictionary *)handleParameters:(NSDictionary *)params {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:params];
    if ([MZLSharedData isAppUserLogined]) {
        [result setObject:[MZLSharedData appUserAccessToken] forKey:MZL_KEY_AUTH_ACCESS_TOKEN];
    } else {
        [result setObject:[MZLSharedData appMachineId] forKey:MZL_KEY_MACHINE_ID];
    }
    return result;
}

+ (void)retryNetworkConditionIfNotAvailable:(CO_BLOCK_VOID)retryBlock {
    BOOL (^retryCondition)(void) =  ^BOOL (void) {
        return ! [[Reachability reachabilityForInternetConnection] isReachable];
    };
    co_retryBlock(@[@1, @2, @3], retryBlock, retryCondition);
}

+ (void)runBlockOnNetworkOK:(CO_BLOCK_VOID)block {
    if (! [[Reachability reachabilityForInternetConnection] isReachable]) {
        [self retryNetworkConditionIfNotAvailable:block];
    } else {
        block();
    }
}

+ (id)getObjects:(RKObjectManager *)objectManager atPath:(NSString *)servicePath parameters:(NSDictionary *)params succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    MZLServiceOperation *operation = [[MZLServiceOperation alloc] init];
    CO_BLOCK_VOID getBlock = ^ {
        NSDictionary *parameters = [self handleParameters:params];
        [objectManager getObjectsAtPath:servicePath parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [self onServiceSuccessWithCode:MZL_HTTP_RESPONSECODE_OK operation:operation mappping:mappingResult succBlock:succBlock errorBlock:errorBlock];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [self onServiceError:error operation:operation errorBlock:errorBlock];
        }];
        RKObjectRequestOperation *requestOperation = [self addTimeoutTimerOnLastOperationForObjectManager:objectManager errorBlock:errorBlock];
        operation.internalOper = requestOperation;
    };
    [self runBlockOnNetworkOK:getBlock];
    return operation;
}

/** 注意：post的object本身不能是responseDescriptor mapping的任何关联对象 */
+ (void)postObject:(RKObjectManager *)objectManager object:(NSObject *)object atPath:(NSString *)servicePath parameters:(NSDictionary *)params succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    MZLServiceOperation *operation = [[MZLServiceOperation alloc] init];
    CO_BLOCK_VOID postBlock = ^ {
        NSDictionary *parameters = [self handleParameters:params];
        [objectManager postObject:object path:servicePath parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [self onServiceSuccessWithCode:MZL_HTTP_RESPONSECODE_CREATED operation:operation mappping:mappingResult succBlock:succBlock errorBlock:errorBlock];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [self onServiceError:error operation:operation errorBlock:errorBlock];
        }];
        RKObjectRequestOperation *requestOperation = [self addTimeoutTimerOnLastOperationForObjectManager:objectManager errorBlock:errorBlock];
        operation.internalOper = requestOperation;
    };
    [self runBlockOnNetworkOK:postBlock];
}

+ (void)postObject:(RKObjectManager *)objectManager atPath:(NSString *)servicePath parameters:(NSDictionary *)params succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    [self postObject:objectManager object:params atPath:servicePath parameters:params succBlock:succBlock errorBlock:errorBlock];
}

+ (void)putObject:(RKObjectManager *)objectManager object:(NSObject *)object atPath:(NSString *)servicePath parameters:(NSDictionary *)params succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    MZLServiceOperation *operation = [[MZLServiceOperation alloc] init];
    CO_BLOCK_VOID putBlock = ^ {
        NSDictionary *parameters = [self handleParameters:params];
        [objectManager putObject:object path:servicePath parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [self onServiceSuccessWithCode:MZL_HTTP_RESPONSECODE_OK operation:operation mappping:mappingResult succBlock:succBlock errorBlock:errorBlock];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [self onServiceError:error operation:operation errorBlock:errorBlock];
        }];
        RKObjectRequestOperation *requestOperation = [self addTimeoutTimerOnLastOperationForObjectManager:objectManager errorBlock:errorBlock];
        operation.internalOper = requestOperation;
    };
    [self runBlockOnNetworkOK:putBlock];
}

+ (void)delete:(RKObjectManager *)objectManager object:(NSObject *)object atPath:(NSString *)servicePath parameters:(NSDictionary *)params succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    MZLServiceOperation *operation = [[MZLServiceOperation alloc] init];
    CO_BLOCK_VOID deleteBlock = ^ {
        // 给delete操作添加默认的responseDescriptor
        [self objectManager:objectManager addDummyResponseDescriptorOnSuccCodesForServicePath:servicePath];
        NSDictionary *parameters = [self handleParameters:params];
        [objectManager deleteObject:object path:servicePath parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [self onServiceSuccessWithCode:MZL_HTTP_RESPONSECODE_OK operation:operation mappping:mappingResult succBlock:succBlock errorBlock:errorBlock];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            // 删除的记录若不存在会返回404，认为成功
            [self onServiceError:error operation:operation succBlock:succBlock errorBlock:errorBlock ignoreStatusCodes:@[@(MZL_HTTP_RESPONSECODE_NOTEXIST)]];
        }];
        RKObjectRequestOperation *requestOperation = [self addTimeoutTimerOnLastOperationForObjectManager:objectManager errorBlock:errorBlock];
        operation.internalOper = requestOperation;
    };
    [self runBlockOnNetworkOK:deleteBlock];
}

#pragma mark - user register service

+ (void)registerServiceWithPath:(NSString *)servicePath param:(MZLRegisterBaseSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    [objectManager setProperty:MZL_SERVICE_TIMER_KEY_TIMEOUT value:@(MZL_REG_TIMEOUT)];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping userRegLogInObjectMapping] servicePath:servicePath]];
    [self postObject:objectManager
              object:param
              atPath:servicePath
          parameters:[param toDictionary]
           succBlock:succBlock
          errorBlock:errorBlock];
}

+ (void)registerServiceWithType:(MZLLoginType)type param:(MZLRegisterBaseSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath;
    switch (type) {
        case MZLLoginTypeWeiXin:
            servicePath = [self servicePath:MZL_SERVICE_REGISTER_WEIXIN];
            break;
        case MZLLoginTypeSinaWeibo:
            servicePath = [self servicePath:MZL_SERVICE_REGISTER_SINA_WEIBO];
            break;
        case MZLLoginTypeQQ:
            servicePath = [self servicePath:MZL_SERVICE_REGISTER_TENCENT_QQ];
            break;
        default:
            servicePath = [self servicePath:MZL_SERVICE_REGISTER];
            break;
    }
    [self registerServiceWithPath:servicePath
                            param:param
                        succBlock:succBlock
                       errorBlock:errorBlock];
}


+ (void)registerByNormalService:(MZLRegisterNormalSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock{
    [self registerServiceWithPath:[self servicePath:MZL_SERVICE_REGISTER]
                            param:param
                        succBlock:succBlock
                       errorBlock:errorBlock];
}

+ (void)registerByWeixinService:(MZLRegister3rdPartySvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    [self registerServiceWithPath:[self servicePath:MZL_SERVICE_REGISTER_WEIXIN]
                            param:param
                        succBlock:succBlock
                       errorBlock:errorBlock];
}

+ (void)registerBySinaWeiboService:(MZLRegisterSinaWeiboSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock{
    [self registerServiceWithPath:[self servicePath:MZL_SERVICE_REGISTER_SINA_WEIBO]
                            param:param
                        succBlock:succBlock
                       errorBlock:errorBlock];
}

+ (void)registerByTencentQqService:(MZLRegisterTencentQqSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock{
    [self registerServiceWithPath:[self servicePath:MZL_SERVICE_REGISTER_TENCENT_QQ]
                            param:param
                        succBlock:succBlock
                       errorBlock:errorBlock];
}


#pragma mark - user login service

+ (void)loginServiceWithPath:(NSString *)servicePath param:(NSDictionary *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping userRegLogInObjectMapping] servicePath:servicePath]];
    [self postObject:objectManager
              object:param
              atPath:servicePath
          parameters:param
           succBlock:succBlock
          errorBlock:errorBlock];
}

+ (void)loginBy3rdPartyWithServicePath:(NSString *)servicePath openId:(NSString *)openId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:openId forKey:MZL_KEY_AUTH_3RD_PARTY_OPENID];
    [self loginServiceWithPath:servicePath param:params succBlock:succBlock errorBlock:errorBlock];
}

+ (void)loginBy3rdPartyWithType:(MZLLoginType)type openId:(NSString *)openId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath;
    switch (type) {
        case MZLLoginTypeWeiXin:
            servicePath = [self servicePath:MZL_SERVICE_WEIXIN_LOGIN];
            break;
        case MZLLoginTypeSinaWeibo:
            servicePath = [self servicePath:MZL_SERVICE_SINA_WEIBO_LOGIN];
            break;
        case MZLLoginTypeQQ:
            servicePath = [self servicePath:MZL_SERVICE_TENCENT_QQ_LOGIN];
            break;
        default:
            servicePath = [self servicePath:MZL_SERVICE_LOGIN];
            break;
    }
    [self loginBy3rdPartyWithServicePath:servicePath openId:openId succBlock:succBlock errorBlock:errorBlock];
}

+ (void)loginByWeiXinServiceWithOpenId:(NSString *)openId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    [self loginBy3rdPartyWithServicePath:[self servicePath:MZL_SERVICE_WEIXIN_LOGIN] openId:openId succBlock:succBlock errorBlock:errorBlock];
}

+ (void)loginBySinaWeiboServiceWithOpenId:(NSString *)openId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    [self loginBy3rdPartyWithServicePath:[self servicePath:MZL_SERVICE_SINA_WEIBO_LOGIN] openId:openId succBlock:succBlock errorBlock:errorBlock];
}

+ (void)loginByTencentQqServiceWithOpenId:(NSString *)openId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    [self loginBy3rdPartyWithServicePath:[self servicePath:MZL_SERVICE_TENCENT_QQ_LOGIN] openId:openId succBlock:succBlock errorBlock:errorBlock];
}

+ (void)loginByNormalService:(MZLLoginSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    [self loginServiceWithPath:[self servicePath:MZL_SERVICE_LOGIN] param:[param toDictionary] succBlock:succBlock errorBlock:errorBlock];
}

#pragma mark - user logout service

+ (void)logoutServiceWithAccesstoken:(NSString *)accessToken succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:accessToken forKey:MZL_KEY_AUTH_ACCESS_TOKEN];

    NSString *servicePath = [self servicePath:MZL_SERVICE_LOGOUT];
    RKObjectManager *objectManager = [self objectManager];
    RKResponseDescriptor *responseDescriptor = [self responseDescriptor:[MZLServiceMapping serviceResponseObjectMapping] servicePath:servicePath];
    [objectManager addResponseDescriptor:responseDescriptor];
    [self getObjects:objectManager atPath:servicePath parameters:params succBlock:succBlock errorBlock:errorBlock];
}

#pragma mark - article related services

+ (void)isArticleFavored:(MZLModelArticle *)article succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_IS_ARTICLE_FAVORED_BY_USER];
    servicePath = [NSString stringWithFormat:servicePath, article.identifier];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping userFavoredArticleResponseObjectMapping] servicePath:servicePath]];
    [self getObjects:objectManager atPath:servicePath parameters:[NSDictionary dictionary] succBlock:succBlock errorBlock:errorBlock];
}

+ (void)favoredLocationsInArticle:(MZLModelArticle *)article succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock; {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_FAVORED_LOCATIONS_IN_ARTICLE];
    servicePath = [NSString stringWithFormat:servicePath, article.identifier];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping userLocationPrefResponseObjectMapping] servicePath:servicePath]];
    [self getObjects:objectManager atPath:servicePath parameters:[NSDictionary dictionary] succBlock:succBlock errorBlock:errorBlock];
}

+ (id)locationArticleListServiceWithLocation:(MZLModelLocationBase *)location pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    return [self locationArticleListServiceWithLocation:location pagingParam:pagingParam filter:nil succBlock:succBlock errorBlock:errorBlock];
}

+ (id)locationArticleListServiceWithLocation:(MZLModelLocationBase *)location pagingParam:(MZLPagingSvcParam *)pagingParam filter:(MZLFilterParam *)filter succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *serviceUrl = [[self serviceUrl_v2:MZL_SERVICE_LOCATION_SHORT_ARTICLES] co_stringWithIntegerParam:location.identifier];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLModelShortArticle rkObjectMapping] servicePath:serviceUrl]];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:[pagingParam toDictionary]];
    if (filter) {
        [paramDict addEntriesFromDictionary:[filter toDictionary]];
    }
    return [self getObjects:objectManager atPath:serviceUrl parameters:paramDict succBlock:succBlock errorBlock:errorBlock];
}

+ (id)locationArticleListServiceWithLocationId:(NSNumber *)locationId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    MZLArticleListSvcParam *param = [MZLArticleListSvcParam instanceWithDefaultPagingParam]; // [[MZLArticleListSvcParam alloc]init];
    param.locationId = [locationId integerValue];
    return [self locationArticleListService:param succBlock:succBlock errorBlock:errorBlock];
}

+ (id)locationArticleListService:(MZLArticleListSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath = [self servicePath:MZL_SERVICE_LOCATION_ARTICLES];
    servicePath = [NSString stringWithFormat:servicePath, param.locationId];
    return [self articleListService:param
                        servicePath:servicePath
                 responseDescriptor:[self responseDescriptor:[MZLServiceMapping articleObjectMapping] servicePath:servicePath]
                          succBlock:succBlock
                         errorBlock:errorBlock];
}

+ (id)articleListServiceWithLocationName:(NSString *)locationName succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    MZLArticleListSvcParam *param = [MZLArticleListSvcParam instanceWithDefaultPagingParam];
    param.locationName = locationName;
    return [self articleListService:param
                          succBlock:succBlock
                         errorBlock:errorBlock];
}

+ (id)articleListService:(MZLArticleListSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath = [self servicePath:MZL_SERVICE_ARTICLES];
    return [self articleListService:param
                        servicePath:servicePath
                 responseDescriptor:[self responseDescriptor:[MZLServiceMapping selectedArticleListResponseObjectMapping] servicePath:nil]
                          succBlock:succBlock
                         errorBlock:errorBlock];
}

+ (id)systemArticleListService:(MZLArticleListSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath = [self servicePath:MZL_SERVICE_SYSTEM_ARTICLES];
    return [self articleListService:param
                        servicePath:servicePath
                 responseDescriptor:[self responseDescriptor:[MZLServiceMapping selectedArticleListResponseObjectMapping] servicePath:servicePath]
                          succBlock:succBlock
                         errorBlock:errorBlock];
}

+ (id)articleListService:(MZLArticleListSvcParam *)param servicePath:(NSString *)servicePath responseDescriptor:(RKResponseDescriptor *)responseDescriptor succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    [objectManager addResponseDescriptor:responseDescriptor];
    return [self getObjects:objectManager atPath:servicePath parameters:[param toDictionary] succBlock:succBlock errorBlock:errorBlock];
}

+ (void)articleDetailService:(MZLModelArticle *)article succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_ARTICLE_DETAIL];
    servicePath = [NSString stringWithFormat:servicePath, article.identifier];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping articleDetailObjectMapping] servicePath:servicePath]];
    [self getObjects:objectManager atPath:servicePath parameters:nil succBlock:succBlock errorBlock:errorBlock];
}

#pragma mark - location related service

+ (id)locationListServiceWithSuccBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_LOCATIONS];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping locationObjectMapping] servicePath:servicePath]];
    return [self getObjects:objectManager atPath:servicePath parameters:nil succBlock:succBlock errorBlock:errorBlock];
}

+ (id)locationListServiceFromCurrentLocation:(NSString *)location succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    return [self locationListServiceFromCurrentLocation:location pagingParam:nil succBlock:succBlock errorBlock:errorBlock];
}

+ (id)locationListServiceFromCurrentLocation:(NSString *)location pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_LOCATIONS_DEFAULT];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping locationListResponseObjectMapping] servicePath:nil]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:isEmptyString(location) ? @"" : location forKey:MZL_SERVICE_PARAM_KEY_DESTINATION_NAME];
    if (pagingParam) {
        [params addEntriesFromDictionary:[pagingParam toDictionary]];
    }
    return [self getObjects:objectManager atPath:servicePath parameters:params succBlock:succBlock errorBlock:errorBlock];
}

+ (void)_locationDetailService:(NSInteger)locationId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_LOCATIONDETAIL];
    servicePath = [NSString stringWithFormat:servicePath, locationId];
    RKResponseDescriptor *locationDetailResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[MZLServiceMapping locationDetailObjectMapping] method:RKRequestMethodAny pathPattern:servicePath keyPath:@"destination" statusCodes:nil];
    RKResponseDescriptor *userLocationPrefResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[MZLServiceMapping userLocationPrefObjectMapping] method:RKRequestMethodAny pathPattern:servicePath keyPath:@"want" statusCodes:nil];
    [objectManager addResponseDescriptor:locationDetailResponseDescriptor];
    [objectManager addResponseDescriptor:userLocationPrefResponseDescriptor];
    [self getObjects:objectManager atPath:servicePath parameters:[NSDictionary dictionary] succBlock:succBlock errorBlock:errorBlock];
}

+ (id)locationDetailService:(NSInteger)locationId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *serviceUrl = [[self serviceUrl_v2:MZL_SERVICE_LOCATIONDETAIL] co_stringWithIntegerParam:locationId];
//    NSString *servicePath = [self servicePath:MZL_SERVICE_LOCATIONDETAIL_NEW integerParam:locationId];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping locationDetailObjectMapping] servicePath:nil]];
    return [self getObjects:objectManager atPath:serviceUrl parameters:[NSDictionary dictionary] succBlock:succBlock errorBlock:errorBlock];
}

+ (id)locationGoodsService:(MZLModelLocationBase *)location pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *serviceUrl = [[self serviceUrl_v2:MZL_SERVICE_LOCATION_GOODS] co_stringWithIntegerParam:location.identifier];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLModelGoods rkObjectMapping]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (pagingParam) {
        [params addEntriesFromDictionary:[pagingParam toDictionary]];
    }
    return [self getObjects:objectManager atPath:serviceUrl parameters:params succBlock:succBlock errorBlock:errorBlock];
}

+ (void)childLocationsService:(MZLChildLocationsSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_CHILDLOCATIONS];
    servicePath = [NSString stringWithFormat:servicePath, param.parentLocationId];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping locationObjectMapping] servicePath:servicePath]];
    [self getObjects:objectManager atPath:servicePath parameters:[param toDictionary] succBlock:succBlock errorBlock:errorBlock];
}

+ (void)locationPhotosService:(NSInteger)locationId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_LOCATION_PHOTOS integerParam:locationId];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping imageObjectMapping] servicePath:servicePath]];
    [self getObjects:objectManager atPath:servicePath parameters:nil succBlock:succBlock errorBlock:errorBlock];
}

+ (id)locationPhotosService:(MZLModelLocationBase *)location pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_LOCATION_PHOTOS integerParam:location.identifier];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping imageObjectMapping] servicePath:servicePath]];
    return [self getObjects:objectManager atPath:servicePath parameters:[pagingParam toDictionary] succBlock:succBlock errorBlock:errorBlock];
}

+ (void)isLocationFavoredService:(MZLModelLocationBase *)location succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_LOCATION_IS_FAVORED integerParam:location.identifier];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping userLocationPrefResponseObjectMapping] servicePath:servicePath]];
    [self getObjects:objectManager atPath:servicePath parameters:nil succBlock:succBlock errorBlock:errorBlock];
}

#pragma mark - favored articles

+ (id)favoredArticlesWithPagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_GETFAVOREDARTICLES];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping userFavoredArticleObjectMapping] servicePath:servicePath]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (pagingParam) {
        [params addEntriesFromDictionary:[pagingParam toDictionary]];
    }
    return [self getObjects:objectManager atPath:servicePath parameters:params succBlock:succBlock errorBlock:errorBlock];
}

+ (void)removeFavoredArticle:(MZLModelUserFavoredArticle *)favoredArticle succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_REMOVEFAVOREDARTICLE];
    servicePath = [NSString stringWithFormat:servicePath, favoredArticle.identifier];
    [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_USER_FAVOR_ARTICLE_UPDATED];
    [self delete:objectManager object:@(favoredArticle.identifier) atPath:servicePath parameters:nil succBlock:succBlock errorBlock:errorBlock];
}

+ (void)addFavoredArticle:(NSInteger)articleId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_ADDFAVOREDARTICLE];
    
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping userFavoredArticleResponseObjectMapping] servicePath:servicePath]];
    NSMutableDictionary *postObject = [NSMutableDictionary dictionary];
    [postObject setObject:@(articleId) forKey:@"article_id"];
    [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_USER_FAVOR_ARTICLE_UPDATED];
    [self postObject:objectManager object:postObject atPath:servicePath parameters:postObject succBlock:succBlock errorBlock:errorBlock];
}

#pragma mark - favored locations

+ (id)favoredLocationsWithPagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self serviceUrl_v2:MZL_SERVICE_GETFAVOREDLOCATIONS]; 
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping userLocationPrefObjectMapping] servicePath:servicePath]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (pagingParam) {
        [params addEntriesFromDictionary:[pagingParam toDictionary]];
    }
    return [self getObjects:objectManager atPath:servicePath parameters:params succBlock:succBlock errorBlock:errorBlock];
}

+ (void)removeFavoredLocation:(MZLModelUserLocationPref *)favoredLocation succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_REMOVEFAVOREDLOCATION];
    servicePath = [NSString stringWithFormat:servicePath, favoredLocation.identifier];
    [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_USER_FAVOR_LOCATION_UPDATED];
    [self delete:objectManager object:@(favoredLocation.identifier) atPath:servicePath parameters:nil succBlock:succBlock errorBlock:errorBlock];
}

+ (void)addLocationAsFavored:(NSInteger)locationId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock  {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_ADDFAVOREDLOCATION];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping userLocationPrefResponseObjectMapping] servicePath:servicePath]];
    NSMutableDictionary *postObject = [NSMutableDictionary dictionary];
    [postObject setObject:@(locationId) forKey:@"destination_id"];
    [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_USER_FAVOR_LOCATION_UPDATED];
    [self postObject:objectManager object:postObject atPath:servicePath parameters:postObject succBlock:succBlock errorBlock:errorBlock];
}

#pragma mark - author related services

+ (void)authorDetailService:(NSNumber *)authorId succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *serviceUrl = [self servicePath:MZL_SERVICE_USER_INFO integerParam:[authorId integerValue]];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLModelUser rkObjectMapping] servicePath:serviceUrl keyPath:@"user"]];
    [self getObjects:objectManager atPath:serviceUrl parameters:nil succBlock:succBlock errorBlock:errorBlock];
}

+ (id)authorArticleListService:(NSNumber *)authorId pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_AUTHOR_ARTICLES];
    servicePath = [NSString stringWithFormat:servicePath, [authorId integerValue]];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping articleObjectMapping] servicePath:servicePath]];
    return [self getObjects:objectManager atPath:servicePath parameters:[pagingParam toDictionary] succBlock:succBlock errorBlock:errorBlock];
}

#pragma mark - 记录用户的最后选择地点，跟通知的deviceToken绑定

+ (void)recordUserLocation:(NSString *)locationName {
    NSString *deviceToken = [MZLSharedData deviceTokenForNotification];
    if (isEmptyString(locationName) || isEmptyString(deviceToken)) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[MZLSharedData appMachineId] forKey:MZL_KEY_MACHINE_ID];
    [params setObject:[MZLSharedData deviceTokenForNotification] forKey:MZL_KEY_NOTI_DEVICE_TOKEN];
    NSInteger userId = -1;
    if ([MZLSharedData isAppUserLogined]) {
        userId = [MZLSharedData appUser].user.identifier;
    }
    [params setObject:@(userId) forKey:@"user_id"];
    [params setObject:locationName forKey:MZL_SERVICE_PARAM_KEY_DESTINATION_NAME];
    
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_RECORD_USER_LOCATION];
    [self objectManager:objectManager addDummyResponseDescriptorOnSuccCodesForServicePath:nil];
    [objectManager postObject:params path:servicePath parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    }];
}

/**
#pragma mark - 有米激活 service

#define MZL_KEY_YOUMI_IS_ACTIVATED @"MZL_KEY_YOUMI_IS_ACTIVATED"

+ (void)youmiActivationService {
    if (! [ASIdentifierManager sharedManager].isAdvertisingTrackingEnabled) {
        return;
    }
    
    NSNumber *activated = [COPreferences getUserPreference:MZL_KEY_YOUMI_IS_ACTIVATED];
    if (activated && [activated boolValue]) {
        return;
    }
    
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_YOUMI_ACTIVATION];
//    servicePath = [NSString stringWithFormat:@"api%@", servicePath];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping serviceResponseObjectMapping] servicePath:nil]];
    NSString *actTime = [NSString stringWithFormat:@"%ld", (long)([[NSDate date] timeIntervalSince1970])];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSDictionary *param = @{
                            @"app_id" : MZL_APP_STORE_ID,
                            @"ifa" : [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],
                            @"actived_at" : actTime,
                            @"app_version" : appVersion,
                            @"machine_id" : [MZLSharedData userIdentifier]
                            };
    [objectManager putObject:param path:servicePath parameters:param success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//        MZLServiceResponseObject *response = [[mappingResult array] objectAtIndex:0];
//        NSLog(@"Response code - %d", response.error);
        [COPreferences setUserPreference:@(YES) forKey:MZL_KEY_YOUMI_IS_ACTIVATED];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to activate youmi, %@", error);
    }];
    
}

#pragma mark - 友盟广告

+ (void)youmengAdUrlService {
    NSDate *lastDate = dateFromString(@"2014-07-31 00:00:00");
    if ([lastDate timeIntervalSinceNow] < 0) { // no longer need to invoke the url service
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *adUrl = [MobClick getAdURL];
        NSString *encodedAdUrl = [adUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [MZLSharedData setYoumengAdUrl:encodedAdUrl];
    });
}
*/

#pragma mark - image upload

+ (void)uploadUserImageService:(UIImage *)image succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath = [self servicePath:MZL_SERVICE_USER_UPLOAD_IMAGE];
    servicePath = [NSString stringWithFormat:servicePath, [MZLSharedData appUserId]];
    NSDictionary *dict = [self handleParameters:[NSDictionary dictionary]];
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    RKObjectManager *om = [self objectManager];
    [om addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping imageUploadResponseObjectMapping] servicePath:nil]];
    NSMutableURLRequest *request = [om multipartFormRequestWithObject:dict
                                                               method:RKRequestMethodPUT
                                                                 path:servicePath
                                                           parameters:dict
                                            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                
                                                
                                                [formData appendPartWithFileData:data
                                                                            name:@"file"
                                                                        fileName:@"image.jpg"
                                                                        mimeType:@"image/jpeg"];
                                                
                                            }];
    RKObjectRequestOperation *operation = [om objectRequestOperationWithRequest:request
                                                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                                           succBlock([mappingResult array]);
                                                                        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                                            errorBlock(error);
                                                                        }];
    
    [om enqueueObjectRequestOperation:operation];
}

#pragma mark - user info

+ (void)userInfoServiceWithSuccBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_USER_INFO];
    servicePath = [NSString stringWithFormat:servicePath, [MZLSharedData appUserId]];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping userInfoObjectMapping] servicePath:servicePath]];
    
    [self getObjects:objectManager
              atPath:servicePath
          parameters:nil
           succBlock:succBlock
          errorBlock:errorBlock];
}

+ (void)modifyPasswordWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_MODIFY_USER_PASSWORD];
    servicePath = [NSString stringWithFormat:servicePath, [MZLSharedData appUserId]];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping serviceResponseObjectMapping] servicePath:servicePath]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:oldPassword forKey:@"user[old_password]"];
    [params setObject:newPassword forKey:@"user[new_password]"];
    [self putObject:objectManager object:params atPath:servicePath parameters:params succBlock:succBlock errorBlock:errorBlock];
}

+ (void)modifyUserInfo:(MZLModelUserInfoDetail *)user succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_MODIFY_USER_INFO];
    servicePath = [NSString stringWithFormat:servicePath, [MZLSharedData appUserId]];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping serviceResponseObjectMapping] servicePath:servicePath]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(user.sex) forKey:@"user[sex]"];
    [params setObject:user.introduction forKey:@"user[intro]"];
    [self putObject:objectManager object:params atPath:servicePath parameters:params succBlock:succBlock errorBlock:errorBlock];
}

#pragma mark - comments related

+ (void)commentForArticle:(MZLModelArticle *)article pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_ARTICLE_COMMENT integerParam:article.identifier];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLModelComment rkObjectMapping]];
    [self getObjects:objectManager atPath:servicePath parameters:[pagingParam toDictionary] succBlock:succBlock errorBlock:errorBlock];
}

+ (void)addComment:(MZLModelComment *)comment forArticle:(MZLModelArticle *)article succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_ARTICLE_ADD_COMMENT integerParam:article.identifier];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLCommentResponse rkObjectMapping]];
    [self postObject:objectManager object:nil atPath:servicePath parameters:[comment toDictionary] succBlock:succBlock errorBlock:errorBlock];
}

+ (void)removeComment:(MZLModelComment *)comment forArticle:(MZLModelArticle *)article succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_ARTICLE_REMOVE_COMMENT integerParam1:article.identifier integerParam2:comment.identifier];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLServiceResponseObject rkObjectMapping]];
    [self delete:objectManager object:nil atPath:servicePath parameters:nil succBlock:succBlock errorBlock:errorBlock];
}

#pragma mark - notices related

+ (id)noticeFromLastDate:(NSDate *)date succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    [MZLAppNotices setLastRequestDateToNow];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%f",[date timeIntervalSince1970]]  forKey:@"last_modify"];
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_NOTICES];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLModelNotice rkObjectMapping]];
    return [self getObjects:objectManager atPath:servicePath parameters:params succBlock:succBlock errorBlock:errorBlock];
}

+ (id)noticeFromLocalWithsuccBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    return [self noticeFromLastDate:[MZLAppNotices lastRequestDate] succBlock:^(NSArray *models) {
        if (models.count > 0) {
            [MZLAppNotices addMessages:models];
        }
        succBlock([MZLAppNotices allMessages]);
    } errorBlock:^(NSError *error) {
        errorBlock(error);
    }];
}

+ (void)removeNoticeFromLocal:(MZLModelNotice *)notice succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    [MZLAppNotices removeMessage:notice];
    dispatch_async(dispatch_get_main_queue(), ^{
        succBlock([MZLAppNotices allMessages]);
    });
}

#pragma mark - 404 page URL

+ (NSString *)urlForCode404 {
    return @"http://www.meizhouliu.com/404.html";
}

#pragma mark - configuration related service

//+ (void)saveSystemLocations:(NSArray *)systemLocations {
////    [MZLSysLocationLocalStore saveSysLocations:systemLocations];
//    NSMutableString *locationNames = [NSMutableString string];
//    NSInteger i = 0;
//    for (MZLModelSystemLocation *systemLocation in systemLocations) {
//        [locationNames appendString:systemLocation.name];
//        if (i != systemLocations.count - 1) {
//            [locationNames appendString:@" "];
//        }
//        i ++;
//    }
//    NSString *oldLocationNames = [COPreferences getUserPreference:MZL_KEY_CACHED_SYSTEM_LOCATIONS];
//    NSLog(@"%@", oldLocationNames);
//    if (! [locationNames isEqualToString:oldLocationNames]) {
//        [COPreferences setUserPreference:locationNames forKey:MZL_KEY_CACHED_SYSTEM_LOCATIONS];
//        refreshSystemLocations();
//    }
//}

+ (void)keywordsService {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *servicePath = [self servicePath:MZL_SERVICE_KEYWORDS];
        servicePath = [MZL_SERVICE_BASE_URL stringByAppendingString:servicePath];
        NSError *error;
        NSString *keywords = [NSString stringWithContentsOfURL:[NSURL URLWithString:servicePath] encoding:NSUTF8StringEncoding error:&error];
        if (! isEmptyString(keywords)) {
            NSData *data = [keywords dataUsingEncoding:NSUTF8StringEncoding];
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if ([jsonObject isKindOfClass:[NSArray class]]) {
                NSArray *keywordArray = (NSArray *)jsonObject;
                keywords = [keywordArray componentsJoinedByString:@"|"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [COPreferences setUserPreference:keywords forKey:MZL_KEY_CACHED_KEYWORDS];
                });
            }            
        }
    });
}

+ (void)checkSystemLocations {
    NSDate *lastCheckDate = [COPreferences getUserPreference:MZL_KEY_CACHED_SYSLOC_UPDATE_TIME];
    if (lastCheckDate) {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastCheckDate];
        if (interval < 30.0 * 24.0 * 3600.0) { // 30 days refresh interval
            // close store as all data has been cached
            [MZLSysLocationLocalStore closeStore];
            return;
        }
    }
    [MZLServices cityListService];
    [MZLServices systemLocationListService];
}

+ (void)systemLocationListService {
    NSString *servicePath = [self servicePath:MZL_SERVICE_SYSTEMLOCATIONLIST];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLModelSystemLocation rkObjectMapping]];
    [self getObjects:objectManager atPath:servicePath parameters:nil succBlock:^(NSArray *models) {
        [MZLSysLocationLocalStore saveSysLocations:models];
    } errorBlock:^(NSError *error) {
        // ignore for the current
    } ];
}

+ (void)cityListService {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *servicePath = [self servicePath:MZL_SERVICE_CITYLIST];
        servicePath = [MZL_SERVICE_BASE_URL stringByAppendingString:servicePath];
        NSError *error;
        NSString *cityList = [NSString stringWithContentsOfURL:[NSURL URLWithString:servicePath] encoding:NSUTF8StringEncoding error:&error];
        if (! isEmptyString(cityList)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [COPreferences setUserPreference:cityList forKey:MZL_KEY_CACHED_CITYLIST];
                [MZLSharedData setAllCities:nil];
                [MZLSharedData setCityPinyinDict:nil];
            });
        }
    });
}

+ (void)filtersListService {
    NSString *servicePath = [self servicePath:MZL_SERVICE_FILTERLIST];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLModelFilterType rkObjectMapping]];
    [self getObjects:objectManager atPath:servicePath parameters:nil succBlock:^(NSArray *models) {
        if (models.count > 0) {
            [MZLSharedData setFilterOptions:models];
        }
    } errorBlock:^(NSError *error) {
        // ignore
    }];
}

+ (void)tagsService {
    NSString *servicePath = [self servicePath:MZL_SERVICE_TAGS];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLModelTagType rkObjectMapping]];
    [self getObjects:objectManager atPath:servicePath parameters:nil succBlock:^(NSArray *models) {
        if (models.count > 0) {
            [MZLModelTagType saveInPreference:models];
        }
    } errorBlock:^(NSError *error) {
        // ignore
    }];
}

#pragma mark - filters

+ (id)filterArticlesServiceWithParam:(MZLFilterParam *)filterParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath = [self servicePath:MZL_SERVICE_FILTER_ARTICLES];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLServiceMapping articleObjectMapping]];
    return [self getObjects:objectManager atPath:servicePath parameters:[filterParam toDictionaryWithDistanceRequired] succBlock:succBlock errorBlock:errorBlock];
}

+ (id)filterLocationsServiceWithParam:(MZLFilterParam *)filterParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath = [self servicePath:MZL_SERVICE_FILTER_LOCATIONS];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLServiceMapping locationObjectMapping]];
    return [self getObjects:objectManager atPath:servicePath parameters:[filterParam toDictionaryWithDistanceRequired] succBlock:succBlock errorBlock:errorBlock];
}

+ (id)filterLocationArticlesServiceOnLocation:(MZLModelLocation *)location param:(MZLFilterParam *)filterParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath = [self servicePath:MZL_SERVICE_FILTER_LOCATION_ARTICLES integerParam:location.identifier];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLServiceMapping articleObjectMapping]];
    return [self getObjects:objectManager atPath:servicePath parameters:[filterParam toDictionary] succBlock:succBlock errorBlock:errorBlock];
}

+ (id)filterChildLocationsService:(MZLChildLocationsSvcParam *)param param:(MZLFilterParam *)filterParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath = [self servicePath:MZL_SERVICE_FILTER_CHILD_LOCATIONS integerParam:param.parentLocationId];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLServiceMapping locationObjectMapping]];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:[param toDictionary]];
    [paramDict addEntriesFromDictionary:[filterParam toDictionary]];
    return [self getObjects:objectManager atPath:servicePath parameters:paramDict succBlock:succBlock errorBlock:errorBlock];
}

#pragma mark - author covers

+ (id)authorCoversServiceWithSuccBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath = [self servicePath:MZL_SERVICE_AUTHOR_COVERS];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLServiceMapping imageObjectMapping]];
    return [self getObjects:objectManager atPath:servicePath parameters:nil succBlock:succBlock errorBlock:errorBlock];
}

+ (void)updateCoverWithCoverId:(NSInteger)identifier succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(identifier) forKey:@"author[cover_id]"];
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_UPDATE_COVER];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping serviceResponseObjectMapping] servicePath:servicePath]];
    [self putObject:objectManager object:params atPath:servicePath parameters:params succBlock:succBlock errorBlock:errorBlock];
}

#pragma mark - data tracking

/** 启动时发送一条消息到服务端，方便统计 */
+ (void)heartbeatOnAppStartup {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_APP_HEARTBEAT];
    [objectManager addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping serviceResponseObjectMapping] servicePath:servicePath]];
    [self getObjects:objectManager atPath:servicePath parameters:nil succBlock:^(NSArray *models) {
    } errorBlock:^(NSError *error) {
    }];
}

#pragma mark - personalize

+ (id)personalizeServiceWithParam:(MZLPersonalizeSvcParam *)param filter:(MZLFilterParam *)filter succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock
{
//    NSString *servicePath = [self servicePath:MZL_SERVICE_PERSONALIZE];
    NSString *servicePath = [self serviceUrl_v2:MZL_SERVICE_PERSONALIZE];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLServiceMapping locationDetailObjectMapping]];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict addEntriesFromDictionary:[param toDictionary]];
    if (! filter) {
        filter = [[MZLFilterParam alloc] init];
    }
    [paramDict addEntriesFromDictionary:[filter toDictionaryWithDistanceRequired]];
    return [self getObjects:objectManager atPath:servicePath parameters:paramDict succBlock:succBlock errorBlock:errorBlock];
}

+ (id)cityPersonalizeServiceWithLocation:(NSString *)location filter:(MZLFilterParam *)filter succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
//    NSString *servicePath = [self servicePath:MZL_SERVICE_PERSONALIZE_CITIES];
    NSString *servicePath = [self serviceUrl_v2:MZL_SERVICE_PERSONALIZE_CITIES];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLServiceMapping locationBaseObjectMapping]];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:location forKey:MZL_SERVICE_PARAM_KEY_DESTINATION_NAME];
    if (! filter) {
        filter = [[MZLFilterParam alloc] init];
    }
    [paramDict addEntriesFromDictionary:[filter toDictionaryWithDistanceRequired]];
    return [self getObjects:objectManager atPath:servicePath parameters:paramDict succBlock:succBlock errorBlock:errorBlock];
}

+ (id)locationPersonalizeCoverServiceWithLocation:(MZLModelLocationBase *)location succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath = [[self serviceUrl_v2:MZL_SERVICE_PERSONALIZE_LOCATION_COVER] co_stringWithIntegerParam:location.identifier];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLServiceMapping locationBaseObjectMapping]];
    return [self getObjects:objectManager atPath:servicePath parameters:nil succBlock:succBlock errorBlock:errorBlock];
}

+ (id)locationPersonalizeDespServiceWithLocation:(MZLModelLocationBase *)location filter:(MZLFilterParam *)filter succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath = [[self serviceUrl_v2:MZL_SERVICE_PERSONALIZE_LOCATION_DESP] co_stringWithIntegerParam:location.identifier];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLModelLocationDesp rkObjectMapping]];
    return [self getObjects:objectManager atPath:servicePath parameters:[filter toDictionary] succBlock:succBlock errorBlock:errorBlock];
}

+ (id)locationPersonalizeServiceWithLocation:(MZLModelLocationBase *)location filter:(MZLFilterParam *)filter succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath = [self servicePath:MZL_SERVICE_PERSONALIZE_LOCATION integerParam:location.identifier];
    RKObjectManager *objectManager = [self objectManager];
    RKResponseDescriptor *locationResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[MZLServiceMapping locationDetailObjectMapping] method:RKRequestMethodAny pathPattern:servicePath keyPath:@"destination" statusCodes:nil];
    RKResponseDescriptor *articlesResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[MZLServiceMapping articleDetailObjectMapping] method:RKRequestMethodAny pathPattern:servicePath keyPath:@"articles" statusCodes:nil];
    [objectManager addResponseDescriptor:locationResponseDescriptor];
    [objectManager addResponseDescriptor:articlesResponseDescriptor];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict addEntriesFromDictionary:[filter toDictionary]];
    return [self getObjects:objectManager atPath:servicePath parameters:paramDict succBlock:succBlock errorBlock:errorBlock];
}

+ (id)locationPersonalizeTagDespServiceWithLocation:(MZLModelLocationBase *)location filter:(MZLFilterParam *)filter succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath = [self servicePath:MZL_SERVICE_PERSONALIZE_LOCATION_TAG_DESP numberParam:@(location.identifier)];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLModelTagDesp rkObjectMapping]];
    return [self getObjects:objectManager atPath:servicePath parameters:[filter toDictionary] succBlock:succBlock errorBlock:errorBlock];
}

+ (id)relatedLocationPersonalizeService:(MZLChildLocationsSvcParam *)param param:(MZLFilterParam *)filterParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
//    NSString *servicePath = [self servicePath:MZL_SERVICE_PERSONALIZE_CHILD_LOCATIONS_DESCENDANTS integerParam:param.parentLocationId];
    NSString *serviceUrl = [[self serviceUrl_v2:MZL_SERVICE_PERSONALIZE_CHILD_LOCATIONS_DESCENDANTS] co_stringWithIntegerParam:param.parentLocationId];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLModelRelatedLocation rkObjectMapping]];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:[param toDictionary]];
    [paramDict addEntriesFromDictionary:[filterParam toDictionary]];
    return [self getObjects:objectManager atPath:serviceUrl parameters:paramDict succBlock:succBlock errorBlock:errorBlock];
}

+ (id)relatedLocationPersonalizeExtService:(MZLModelLocationBase *)parentLocation param:(MZLDescendantsParam *)descendantsParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
     NSString *serviceUrl = [[self serviceUrl_v2:MZL_SERVICE_PERSONALIZE_CHILD_LOCATIONS_DESCENDANTS_INFO] co_stringWithIntegerParam:parentLocation.identifier];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLModelRelatedLocationExt rkObjectMapping]];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithDictionary:[descendantsParam toDictionary]];
//    [paramDict addEntriesFromDictionary:[descendantsParam toDictionary]];
    return [self getObjects:objectManager atPath:serviceUrl parameters:paramDict succBlock:succBlock errorBlock:errorBlock];
}

#pragma mark - goods related

/** 检测一篇文章是否有相关的商品 */
+ (BOOL)hasGoodsFlagWithArticle:(MZLModelArticle *)arg1 {
    
    NSString *servicePath = [self servicePath:[NSString stringWithFormat:MZL_SERVICE_ARTICLE_GOODS_FLAG,@(arg1.identifier)]];
    servicePath = [MZL_SERVICE_BASE_URL stringByAppendingString:servicePath];
    NSString *hasGoodsFlag;
    NSError *error;
    hasGoodsFlag = [NSString stringWithContentsOfURL:[NSURL URLWithString:servicePath] encoding:NSUTF8StringEncoding error:&error];
    if ([hasGoodsFlag isEqualToString:@"true"]) {
        return YES;
    }
    return NO;
}

/** 获取文章相关的商品 */
+ (void)goodsInArticle:(MZLModelArticle *)article succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_ARTICLE_GOODS integerParam:article.identifier];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLModelGoodsDetail rkObjectMapping]];
    [self getObjects:objectManager atPath:servicePath parameters:[NSDictionary dictionary] succBlock:succBlock errorBlock:errorBlock];
}

+ (void)hotGoodsService:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *selectedCity = [MZLSharedData selectedCity];
    NSString *serviceUrl;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (pagingParam) {
        [params addEntriesFromDictionary:[pagingParam toDictionary]];
    }
    if (isEmptyString(selectedCity)) {
        serviceUrl = [self serviceUrl_v1:MZL_SERVICE_HOT_PRODUCTS];
    } else {
        serviceUrl = [self serviceUrl_v2:MZL_SERVICE_LOCATION_HOT_PRODUCTS];
        params[MZL_SERVICE_PARAM_KEY_DESTINATION_NAME] = selectedCity;
    }
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLModelGoods rkObjectMapping]];
    [self getObjects:objectManager atPath:serviceUrl parameters:params succBlock:succBlock errorBlock:errorBlock];
}

#pragma mark - 友盟广告

+ (void)youmengAdUrlService {
    NSDate *lastDate = dateFromString(@"2015-11-01 00:00:00");
    if ([lastDate timeIntervalSinceNow] < 0) { // no longer need to invoke the url service
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *adUrl = [MobClick getAdURL];
        NSString *encodedAdUrl = [adUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [MZLSharedData setYoumengAdUrl:encodedAdUrl];
    });
}

#pragma mark - short articles

+ (id)shortArticleDetailServiceWithId:(NSInteger)identifier succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath = [[self serviceUrl_v1:MZL_SERVICE_SHORT_ARTICLE_DETAIL] co_stringWithIntegerParam:identifier];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLModelShortArticle rkObjectMapping]];
    return [self getObjects:objectManager atPath:servicePath parameters:nil succBlock:succBlock errorBlock:errorBlock];
}

+ (id)personalizeShortArticleServiceWithFilter:(MZLFilterParam *)filter pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath = [self servicePath:MZL_SERVICE_PERSONALIZE_SHORT_ARTICLE];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLModelShortArticle rkObjectMapping]];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict addEntriesFromDictionary:[pagingParam toDictionary]];
    if (! filter) {
        filter = [[MZLFilterParam alloc] init];
    }
    [paramDict addEntriesFromDictionary:[filter toDictionaryWithDistanceRequired]];
    return [self getObjects:objectManager atPath:servicePath parameters:paramDict succBlock:succBlock errorBlock:errorBlock];
}

+ (id)authorShortArticleListWithAuthor:(MZLModelAuthor *)author pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *serviceUrl = [[self servicePath:MZL_SERVICE_SHORT_ARTICLE_LIST_AUTHOR] co_stringWithIntegerParam:author.identifier];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLModelShortArticle rkObjectMapping]];
    return [self getObjects:objectManager atPath:serviceUrl parameters:[pagingParam toDictionary] succBlock:succBlock errorBlock:errorBlock];
}

+ (id)authorShortArticleListWithPagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath = [self servicePath:MZL_SERVICE_SHORT_ARTICLE_LIST_OWN];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLModelShortArticle rkObjectMapping]];
    return [self getObjects:objectManager atPath:servicePath parameters:[pagingParam toDictionary] succBlock:succBlock errorBlock:errorBlock];
}

+ (void)addUpForShortArticle:(MZLModelShortArticle *)shortArticle succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *serviceUrl = [[self servicePath:MZL_SERVICE_SHORT_ARTICLE_ADDUP] co_stringWithIntegerParam:shortArticle.identifier];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLServiceResponseObject rkObjectMapping]];
    [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_USER_UP_ARTICLE_UPDATED];
    [self postObject:objectManager object:shortArticle atPath:serviceUrl parameters:nil succBlock:succBlock errorBlock:errorBlock];
}

+ (void)removeUpForShortArticle:(MZLModelShortArticle *)shortArticle succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *serviceUrl = [[self servicePath:MZL_SERVICE_SHORT_ARTICLE_REMOVEUP] co_stringWithIntegerParam:shortArticle.identifier];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLServiceResponseObject rkObjectMapping]];
    [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_USER_UP_ARTICLE_UPDATED];
    [self delete:objectManager object:shortArticle atPath:serviceUrl parameters:nil succBlock:succBlock errorBlock:errorBlock];
}

+ (id)upStatusForShortArticle:(MZLModelShortArticle *)shortArticle succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *serviceUrl = [[self servicePath:MZL_SERVICE_SHORT_ARTICLE_GETUP] co_stringWithIntegerParam:shortArticle.identifier];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLShortArticleUpResponse rkObjectMapping]];
    return [self getObjects:objectManager atPath:serviceUrl parameters:nil succBlock:succBlock errorBlock:errorBlock];
}

+ (void)addComment:(MZLModelShortArticleComment *)comment forShortArticle:(MZLModelShortArticle *)shortArticle succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *serviceUrl = [[self servicePath:MZL_SERVICE_SHORT_ARTICLE_ADDCOMMENT] co_stringWithIntegerParam:shortArticle.identifier];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLShortArticleCommentResponse rkObjectMapping]];
    [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_SHORT_ARTICLE_COMMENT_UPDATED];
    [self postObject:objectManager atPath:serviceUrl parameters:[comment toDictionary] succBlock:succBlock errorBlock:errorBlock];
}

+ (void)removeComment:(MZLModelShortArticleComment *)comment forShortArticle:(MZLModelShortArticle *)shortArticle succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *serviceUrl = [[self servicePath:MZL_SERVICE_SHORT_ARTICLE_REMOVECOMMENT] co_stringWithIntegerParam1:shortArticle.identifier intergerParam2:comment.identifier];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLServiceResponseObject rkObjectMapping]];
    [IBMessageCenter sendGlobalMessageNamed:MZL_NOTIFICATION_SHORT_ARTICLE_COMMENT_UPDATED];
    [self delete:objectManager object:[NSDictionary dictionary] atPath:serviceUrl parameters:nil succBlock:succBlock errorBlock:errorBlock];
}

+ (id)commentsForShortArticle:(MZLModelShortArticle *)shortArticle pagingParam:(MZLPagingSvcParam *)pagingParam succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath = [[self servicePath:MZL_SERVICE_SHORT_ARTICLE_GETCOMMENTS] co_stringWithIntegerParam:shortArticle.identifier];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLModelShortArticleComment rkObjectMapping]];
    return [self getObjects:objectManager atPath:servicePath parameters:[pagingParam toDictionary] succBlock:succBlock errorBlock:errorBlock];
}

+ (void)surroundingLocations:(MZLSurroundingLocSvcParam *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    AMapPlaceSearchRequest *searchRequest = [[AMapPlaceSearchRequest alloc] init];
    // 搜索类型为高德地图POI类型的05大类（餐饮服务）、06大类（购物服务）、08大类（体育休闲服务）、10大类（住宿服务）、11大类（风景名胜）、14大类（科教文化服务）、19大类（地名地址信息）
    NSArray *types = @[@"050000", @"060000", @"080000", @"100000", @"110000", @"140000", @"190000"];
    searchRequest.requireExtension = YES;
    if (param.pagingParam) {
        searchRequest.page = param.pagingParam.pageIndex;
        searchRequest.offset = param.pagingParam.fetchCount;
    } else {
        searchRequest.offset = MZL_SVC_FETCHCOUNT;
    }
    if (isEmptyString(param.city)) {
        searchRequest.searchType = AMapSearchType_PlaceAround;
        searchRequest.types = types;
        searchRequest.location = [AMapGeoPoint locationWithLatitude:param.latitude.doubleValue longitude:param.longitude.doubleValue];
    } else {
        searchRequest.searchType = AMapSearchType_PlaceKeyword;
        searchRequest.city = @[[MZLSharedData selectedCity]];
        searchRequest.keywords = param.city;
    }
    AMapSearchAPI *api = [MZLSharedData aMapSearch];
    MZLAMapSearchDelegateForService *delegate = [MZLAMapSearchDelegateForService sharedInstance];
    delegate.svcSuccBlock = succBlock;
    delegate.svcErrorBlock = errorBlock;
    api.delegate = delegate;
    [api AMapPlaceSearch:searchRequest];
}


+ (id)uploadPhoto:(UIImage *)image succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    NSString *servicePath = [self servicePath:MZL_SERVICE_UPLOAD_PHOTO];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [self handleParameters:dict];
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    RKObjectManager *om = [self objectManager];
    [om addResponseDescriptor:[self responseDescriptor:[MZLServiceMapping imageUploadResponseObjectMapping] servicePath:nil]];
    NSMutableURLRequest *request = [om multipartFormRequestWithObject:dict
                                                               method:RKRequestMethodPOST
                                                                 path:servicePath
                                                           parameters:dict
                                            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                [formData appendPartWithFileData:data
                                                                            name:@"file"
                                                                        fileName:@"image.jpg"
                                                                        mimeType:@"image/jpeg"];
                                                
                                            }];
    RKObjectRequestOperation *operation = [om objectRequestOperationWithRequest:request
                                                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                                            succBlock([mappingResult array]);
                                                                        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                                            errorBlock(error);
                                                                        }];
    
    [om enqueueObjectRequestOperation:operation];
    return operation;
}


+ (void)postShortArticleService:(MZLModelShortArticle *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *servicePath = [self servicePath:MZL_SERVICE_SHORT_ARTICLE_ADD];
    [objectManager setProperty:MZL_SERVICE_TIMER_KEY_TIMEOUT value:@(MZL_REG_TIMEOUT)];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLShortArticleResponse rkObjectMapping]];
    [self postObject:objectManager atPath:servicePath parameters:[param toDictionary] succBlock:succBlock errorBlock:errorBlock];
}

+ (void)removeShortArticle:(MZLModelShortArticle *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *serviceUrl = [[self servicePath:MZL_SERVICE_SHORT_ARTICLE_REMOVE] co_stringWithIntegerParam:param.identifier];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLServiceResponseObject rkObjectMapping]];
    [self delete:objectManager object:[NSDictionary dictionary] atPath:serviceUrl parameters:nil succBlock:succBlock errorBlock:errorBlock];
}

+ (void)shareShortArticleServiceWithId:(NSInteger)identifier {
    RKObjectManager *objectManager = [self objectManager];
    NSString *serviceUrl = [[self serviceUrl_v1:MZL_SERVICE_SHORT_ARTICLE_SHARE] co_stringWithIntegerParam:identifier];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLServiceResponseObject rkObjectMapping]];
    [self postObject:objectManager atPath:serviceUrl parameters:nil succBlock:^(NSArray *models) {
    }  errorBlock:^(NSError *error) {
    }];
}

+ (void)aMapLocationQuery:(MZLModelSurroundingLocations *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *serviceUrl = [NSString stringWithFormat:[self serviceUrl_v1:MZL_SERVICE_AMAP_LOCATION_QUERY], param.aMapId];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLModelSurroundingLocations rkObjectMapping]];
    [self getObjects:objectManager atPath:serviceUrl parameters:nil succBlock:succBlock errorBlock:errorBlock];
}

+ (void)aMapLocationCreate:(MZLModelSurroundingLocations *)param succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock {
    RKObjectManager *objectManager = [self objectManager];
    NSString *serviceUrl = [self serviceUrl_v1:MZL_SERVICE_AMAP_LOCATION_CREATE];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLLocResponse rkObjectMapping]];
    [self postObject:objectManager atPath:serviceUrl parameters:[param toDictionary] succBlock:succBlock errorBlock:errorBlock];
}

+ (void)reportForShortArticle:(MZLModelShortArticle *)shortArticle succBlock:(MZL_SVC_SUCC_BLOCK)succBlock errorBlock:(MZL_SVC_ERR_BLOCK)errorBlock
{
    NSString *serviceUrl = [[self servicePath:MZL_SERVICE_SHORT_ARTICLE_REPORT] co_stringWithIntegerParam:shortArticle.identifier];
    RKObjectManager *objectManager = [self objectManager];
    [self objectManager:objectManager addResponseDescriptorFromMapping:[MZLShortArticleResponse rkObjectMapping]];
    [self postObject:objectManager atPath:serviceUrl parameters:nil succBlock:succBlock errorBlock:errorBlock];
}

@end
