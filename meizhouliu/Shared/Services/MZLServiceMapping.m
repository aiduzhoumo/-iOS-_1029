//
//  MZLServiceMapping.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-16.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLServiceMapping.h"
#import "RestKit/RestKit.h"
#import "MZLModelArticle.h"
#import "MZLModelAuthor.h"
#import "MZLModelLocation.h"
#import "MZLModelImage.h"
#import "MZLModelLocationDetail.h"
#import "MZLModelUserLocationPref.h"
#import "MZLUserLocPrefResponse.h"
#import "MZLModelAuthorDetail.h"
#import "MZLModelUserFavoredArticle.h"
#import "MZLUserFavoredArticleResponse.h"
#import "MZLModelArticleDetail.h"
#import "MZLModelRouteInfo.h"
#import "MZLModelLocationExt.h"
#import "MZLModelTagType.h"
#import "MZLSelectedArticleListResponse.h"
#import "MZLLocListResponse.h"
#import "MZLServiceResponseObject.h"
#import "MZLRegLoginResponse.h"
#import "MZLModelUser.h"
#import "MZLModelAccessToken.h"
#import "MZLServiceResponseDetail.h"
#import "MZLUserDetailResponse.h"
#import "MZLModelUserInfoDetail.h"
#import "MZLImageUploadResponse.h"
#import "MZLBindPhoneResponse.h"

#define ID_MAPPING @"id":@"identifier"
#define TAGS_MAPPING @"tags_str":@"tags"

@implementation MZLServiceMapping

#pragma mark - misc

+ (RKRelationshipMapping *)relMappingToKeyPath:(NSString *)keyPath fromAttr:(NSString *)attr withMapping:(RKObjectMapping *)mapping  {
    return [RKRelationshipMapping relationshipMappingFromKeyPath:keyPath toKeyPath:attr withMapping:mapping];
}

+ (RKRelationshipMapping *)relMappingWithPath:(NSString *)path andMapping:(RKObjectMapping *)mapping  {
    return [self relMappingToKeyPath:path fromAttr:path withMapping:mapping];
}

#pragma mark - image related mapping

+ (NSDictionary *)imageMapping {
    return @{
             ID_MAPPING,
             @"file_url":       @"fileUrl"
             };
}

+ (RKObjectMapping *)imageObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLModelImage class]];
    [result addAttributeMappingsFromDictionary:[self imageMapping]];
    return result;
}

#pragma mark - route info mapping

+ (NSDictionary *)routeInfoMapping {
    return @ {
        @"id":          @"identifier",
        @"day":       @"dayInfo",
    };
}

+ (RKObjectMapping *)routeInfoObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLModelRouteInfo class]];
    [result addAttributeMappingsFromDictionary:[self routeInfoMapping]];
    [result addRelationshipMappingWithSourceKeyPath:@"destinations" mapping:[self locationObjectMapping]];
    return result;
}

#pragma mark - article related mapping

/** used in article list service */
+ (NSDictionary *)articleMapping {
    return @{
                @"id"       :   @"identifier",
                @"essence"  :   @"essence",
                @"title"    :   @"title",
                @"trip_span":   @"span",
                TAGS_MAPPING
            };
}

+ (NSDictionary *)articleDetailMapping {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[self articleMapping]];
    [result addEntriesFromDictionary:@{
                                       @"url":  @"articleUrl",
                                       @"summary" : @"summary",
                                       @"fragment" : @"fragment",
                                       @"comments_count" : @"commentCount"
                                       }];
    return result;
}

+ (NSArray *)articleRelationMapping {
    return @[
             [self relMappingWithPath:@"author" andMapping:[self authorObjectMapping]],
             [self relMappingWithPath:@"destination" andMapping:[self locationObjectMapping]],
             [self relMappingToKeyPath:@"cover" fromAttr:@"coverImage" withMapping:[self imageObjectMapping]]
             ];
}

+ (RKObjectMapping *)articleObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLModelArticle class]];
    [result addAttributeMappingsFromDictionary:[self articleMapping]];
    [result addPropertyMappingsFromArray:[self articleRelationMapping]];
    return result;
}

+ (RKObjectMapping *)articleDetailObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLModelArticleDetail class]];
    [result addAttributeMappingsFromDictionary:[self articleDetailMapping]];
    [result addPropertyMappingsFromArray:[self articleRelationMapping]];
    [result addRelationshipMappingWithSourceKeyPath:@"trips" mapping:[self routeInfoObjectMapping]];
    return result;
}

/** 精选列表 */
+ (NSDictionary *)selectedArticleListResponseMapping {
    return @{
             @"is_system_articles":          @"isSystemArticles"
             };
}

+ (RKObjectMapping *)selectedArticleListResponseObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLSelectedArticleListResponse class]];
    [result addAttributeMappingsFromDictionary:[self selectedArticleListResponseMapping]];
    [result addRelationshipMappingWithSourceKeyPath:@"articles" mapping:[self articleObjectMapping]];
    return result;
}

#pragma mark - author related mapping

+ (NSDictionary *)authorMapping {
    return @{
                @"id":                  @"identifier",
                @"name":                @"name",
            };
}

+ (NSArray *)authorRelationMappings {
    RKRelationshipMapping *relationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"photo" toKeyPath:@"photo" withMapping:[self imageObjectMapping]];
    return @[relationshipMapping];
}


+ (NSDictionary *)authorDetailMapping {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[self authorMapping]];
    [result addEntriesFromDictionary:@{
                                       @"intro":               @"introduction",
                                       @"is_signing":          @"isSignedWriter",
                                       @"destinations_count":  @"totalLocationCount",
                                       TAGS_MAPPING
                                       }];
    return result;
}

+ (RKObjectMapping *)authorDetailObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLModelAuthorDetail class]];
    [result addAttributeMappingsFromDictionary:[self authorDetailMapping]];
    [result addPropertyMappingsFromArray:[self authorRelationMappings]];
    [result addRelationshipMappingWithSourceKeyPath:@"articles" mapping:[self articleObjectMapping]];
    [result addRelationshipMappingWithSourceKeyPath:@"cover" mapping:[self imageObjectMapping]];
    return result;
}

+ (RKObjectMapping *)authorObjectMapping {
    RKObjectMapping *authorMapping = [RKObjectMapping mappingForClass:[MZLModelAuthor class]];
    [authorMapping addAttributeMappingsFromDictionary:[self authorMapping]];
    [authorMapping addPropertyMappingsFromArray:[self authorRelationMappings]];
    return authorMapping;
}

#pragma mark - location related mapping

+ (NSDictionary *)locationBaseMapping {
    return @{
             @"id":             @"identifier",
             @"longitude":          @"longitude",
             @"latitude":           @"latitude",
             @"name":           @"name",
             @"articles_count": @"totalArticleCount",
             @"short_articles_count" : @"shortArticleCount",
             @"is_viewpoint" : @"isViewPoint"
            };
}

+ (NSDictionary *)locationExtMapping {
    return @{
             @"full_address" : @"address",
             @"description"  : @"introduction"
             };
}

+ (NSDictionary *)locationMapping {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[self locationBaseMapping]];
    [result addEntriesFromDictionary:@{
                                       TAGS_MAPPING,
                                       @"wants_count" :   @"interestedPersonCount"
                                       }];
    return result;
}

/** used in destination detail service */
+ (NSDictionary *)locationDetailMapping {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:[self locationBaseMapping]];
    [result addEntriesFromDictionary:@{
                                       @"consumption"       : @"averageConsumption",
                                       @"tags_arr"          : @"tags",
                                       @"descendants_count" : @"totalChildLocationCount",
                                       @"destinations_count": @"relatedLocationCount",
                                       @"top_parent_name"   : @"topParentName",
                                       @"products_count" : @"productsCount"
                                       }];
    return result;
}

+ (NSArray *)locationBaseRelationMappings {
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:[self relMappingToKeyPath:@"cover" fromAttr:@"coverImage" withMapping:[self imageObjectMapping]]];
    [result addObject:[self relMappingToKeyPath:@"destination_detail" fromAttr:@"locationExt" withMapping:[self locationExtObjectMapping]]];
    return result;
}

+ (NSDictionary *)locationListResponseMapping {
    return @{@"type" : @"type"};
}

+ (RKObjectMapping *)locationExtObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLModelLocationExt class]];
    [result addAttributeMappingsFromDictionary:[self locationExtMapping]];
    return result;
}

+ (RKObjectMapping *)locationBaseObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLModelLocationBase class]];
    [result addAttributeMappingsFromDictionary:[self locationBaseMapping]];
    [result addPropertyMappingsFromArray:[self locationBaseRelationMappings]];
    return result;
}

+ (RKObjectMapping *)locationObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLModelLocation class]];
    [result addAttributeMappingsFromDictionary:[self locationMapping]];
    [result addPropertyMappingsFromArray:[self locationBaseRelationMappings]];
    return result;
}

+ (RKObjectMapping *)locationDetailObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLModelLocationDetail class]];
    [result addAttributeMappingsFromDictionary:[self locationDetailMapping]];
    [result addPropertyMappingsFromArray:[self locationBaseRelationMappings]];
    [result addRelationshipMappingWithSourceKeyPath:@"photos" mapping:[self imageObjectMapping]];
    [result addRelationshipMappingWithSourceKeyPath:@"articles" mapping:[self articleObjectMapping]];
    RKRelationshipMapping *relationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"descendants" toKeyPath:@"childLocations" withMapping:[self locationObjectMapping]];
    [result addPropertyMapping:relationshipMapping];
    [result addPropertyMapping:[self relMappingToKeyPath:@"tag_types" fromAttr:@"tagTypes" withMapping:[MZLServiceMapping tagTypeObjectMapping]]];
    [result addPropertyMapping:[self relMappingToKeyPath:@"top_parent" fromAttr:@"topParent" withMapping:[MZLServiceMapping locationBaseObjectMapping]]];
    return result;
}

+ (RKObjectMapping *)locationListResponseObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLLocListResponse class]];
    [result addAttributeMappingsFromDictionary:[self locationListResponseMapping]];
    [result addRelationshipMappingWithSourceKeyPath:@"destinations" mapping:[MZLModelLocation rkObjectMapping]];
    [result addRelationshipMappingWithSourceKeyPath:@"more" mapping:[self locationObjectMapping]];
    return result;
}

#pragma mark - user favored location mapping

+ (NSDictionary *)userLocationPrefMapping {
    return @{
             @"id":                 @"identifier",
             MZL_KEY_MACHINE_ID:         @"userId",
             @"destination_id":     @"locationId"
             };
}

+ (RKObjectMapping *)userLocationPrefObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLModelUserLocationPref class]];
    [result addAttributeMappingsFromDictionary:[self userLocationPrefMapping]];
    RKRelationshipMapping *relationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"destination" toKeyPath:@"location" withMapping:[MZLModelLocation rkObjectMapping]];
    [result addPropertyMapping:relationshipMapping];
    return result;
}

+ (RKObjectMapping *)userLocationPrefResponseObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLUserLocPrefResponse class]];
//    [result addAttributeMappingsFromArray:@[@"error"]];
    [result addAttributeMappingsFromDictionary:[self serviceResponseMapping]];
    [result addPropertyMapping:[self relMappingToKeyPath:@"want" fromAttr:@"userLocationPref" withMapping:[self userLocationPrefObjectMapping]]];
    [result addPropertyMapping:[self relMappingToKeyPath:@"wants" fromAttr:@"userLocationPrefs" withMapping:[self userLocationPrefObjectMapping]]];
    return result;
}

#pragma mark - user favored article mapping

+ (NSDictionary *)userFavoredArticleMapping {
    return @{
             @"id":                 @"identifier",
             MZL_KEY_MACHINE_ID:         @"userId",
             @"article_id":         @"articleId"
             };
}

+ (RKObjectMapping *)userFavoredArticleObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLModelUserFavoredArticle class]];
    [result addAttributeMappingsFromDictionary:[self userFavoredArticleMapping]];
    [result addRelationshipMappingWithSourceKeyPath:@"article" mapping:[self articleObjectMapping]];
    return result;
}

+ (RKObjectMapping *)userFavoredArticleResponseObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLUserFavoredArticleResponse class]];
//    [result addAttributeMappingsFromArray:@[@"error"]];
    [result addAttributeMappingsFromDictionary:[self serviceResponseMapping]];
    RKRelationshipMapping *relationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"favorite" toKeyPath:@"userFavoredArticle" withMapping:[self userFavoredArticleObjectMapping]];
    [result addPropertyMapping:relationshipMapping];
    return result;
}

#pragma mark - service message mapping
+ (RKObjectMapping *)messagesResponseObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLServiceResponseDetail class]];
    [result addAttributeMappingsFromArray:@[ @"field", @"detail" ]];
    return result;
}

#pragma mark - service response mapping

+ (NSDictionary *)serviceResponseMapping {
    return @{
             @"error" : @"error",
             @"message" : @"message"
                         };
}

+ (RKObjectMapping *)serviceResponseObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLServiceResponseObject class]];
    [result addAttributeMappingsFromDictionary:[self serviceResponseMapping]];
    [result addPropertyMapping:[self relMappingToKeyPath:@"messages" fromAttr:@"messages" withMapping:[self messagesResponseObjectMapping]]];
    return result;
}


#pragma mark - tags

+ (NSDictionary *)tagTypeMapping {
    return @{
             ID_MAPPING,
             @"name":         @"name",
             @"tags":         @"tags"
             };
}

+ (RKObjectMapping *)tagTypeObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLModelTagType class]];
    [result addAttributeMappingsFromDictionary:[self tagTypeMapping]];
    return result;
}

#pragma mark - user

+ (NSDictionary *)userMapping {
    return @{
             ID_MAPPING,
             @"nickname":   @"nickName",
             @"level"   :   @"level",
             @"bind"    :   @"bind"
//             @"phone"   :   @"phone"
             };
}

+ (RKObjectMapping *)userObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLModelUser class]];
    [result addAttributeMappingsFromDictionary:[self userMapping]];

    // Define the relationship mapping
    [result addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"photo"
                                                                           toKeyPath:@"headerImage"
                                                                         withMapping:[self imageObjectMapping]]];
    return result;
}


#pragma mark - access token
+ (NSDictionary *) accessTokenMapping{
    return @{
             @"token":             @"token",
             @"refresh_token":         @"refreshToken",
             @"expires_at":       @"expiresAt",
             };
}
+ (RKObjectMapping *)accessTokenObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLModelAccessToken class]];
    [result addAttributeMappingsFromDictionary:[self accessTokenMapping]];
    return result;
}

#pragma mark - userInfo
+ (NSArray *)userInfoBindMappings {
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:[self relMappingToKeyPath:@"user" fromAttr:@"user" withMapping:[self userObjectMapping]]];
    [result addObject:[self relMappingToKeyPath:@"messages" fromAttr:@"messages" withMapping:[self messagesResponseObjectMapping]]];
    return result;
}
+ (NSArray *)userInfoMappings {
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:[self relMappingToKeyPath:@"user" fromAttr:@"user" withMapping:[self userObjectMapping]]];
    [result addObject:[self relMappingToKeyPath:@"access_token" fromAttr:@"accessToken" withMapping:[self accessTokenObjectMapping]]];
    [result addObject:[self relMappingToKeyPath:@"messages" fromAttr:@"messages" withMapping:[self messagesResponseObjectMapping]]];
    return result;
}

+ (RKObjectMapping *)userRegLogInObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLRegLoginResponse class]];
    [result addAttributeMappingsFromArray:@[ @"error",@"message" ]];
    [result addPropertyMappingsFromArray:[self userInfoMappings]];
    return result;
}

+ (RKObjectMapping *)userBindPhoneObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLBindPhoneResponse class]];
    [result addAttributeMappingsFromArray:@[@"error",@"message"]];
    [result addPropertyMappingsFromArray:[self userInfoBindMappings]];
    return result;
}

#pragma mark - user info detail

+ (NSDictionary *) userInfoDetailMapping{
    return @{
             ID_MAPPING,
             @"nickname":         @"nickName",
             @"level":       @"level",
             @"sex":       @"sex",
             @"intro": @"introduction",
             @"bind" : @"bind"
//             @"phone": @"phone"
             };
}

+ (RKObjectMapping *)userInfoDetailObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLModelUserInfoDetail class]];
    [result addAttributeMappingsFromDictionary:[self userInfoDetailMapping]];
    
    // Define the relationship mapping
    [result addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"photo"
                                                                           toKeyPath:@"headerImage"
                                                                         withMapping:[self imageObjectMapping]]];
    [result addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"cover"
                                                                           toKeyPath:@"coverImage"
                                                                         withMapping:[self imageObjectMapping]]];
    return result;
}

+ (RKObjectMapping *)userInfoObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLUserDetailResponse class]];
    [result addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                           toKeyPath:@"user"
                                                                         withMapping:[self userInfoDetailObjectMapping]]];
    return result;
}

#pragma mark - upload image response 

+ (RKObjectMapping *)imageUploadResponseObjectMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[MZLImageUploadResponse class]];
    [result addAttributeMappingsFromArray:@[@"error", @"message"]];
    [result addPropertyMapping:[self relMappingToKeyPath:@"messages" fromAttr:@"messages" withMapping:[self messagesResponseObjectMapping]]];
    [result addPropertyMapping:[self relMappingToKeyPath:@"photo" fromAttr:@"image" withMapping:[self imageObjectMapping]]];
    return result;
}


#pragma mark - dummy mapping

+ (RKObjectMapping *)dummyObjectMapping {
    return [RKObjectMapping mappingForClass:[NSObject class]];
}

@end
