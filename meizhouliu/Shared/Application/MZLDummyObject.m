//
//  MZLDummyObject.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-23.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLDummyObject.h"
#import "MZLServices.h"
#import "MZLPagingSvcParam.h"
#import "MZLChildLocationsSvcParam.h"
#import "MZLModelArticle.h"
#import "RestKit/RestKit.h"
#import "MZLServiceMapping.h"
#import "MZLSharedData.h"
#import "MZLLocationDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "MZLRegisterNormalSvcParam.h"
#import "MZLModelUser.h"
#import "MZLModelUserInfoDetail.h"
#import "MZLAppUser.h"
#import "MZLModelComment.h"
#import "MZLModelFilterType.h"
#import "MZLModelFilterItem.h"
#import "MZLFilterParam.h"
#import "MZLModelLocation.h"

@implementation MZLDummyObject

+ (void)test {
    [self testService];
}

+ (void)testLocation {
    [MZLSharedData startLocationService];
}

+ (void)testService {
    MZLModelLocation *location = [[MZLModelLocation alloc] init];
    location.identifier = 605955;
//    MZLPagingSvcParam *param = [[MZLPagingSvcParam alloc] init];
//    param.pageIndex = 1;
//    param.fetchCount = 20;
//    [MZLServices locationPhotosService:location pagingParam:param succBlock:^(NSArray *models) {
//        NSLog(@"%d", models.count);
//        NSDictionary *dict = [models getProperty:MZL_SVC_RESPONSE_HEADERS];
//        NSLog(@"%@", dict[@"X-Total"]);
//        NSLog(@"%@", dict);
//    } errorBlock:^(NSError *error) {
//        NSLog(@"%@", error);
//    }];
//    NSString *location = @"杭州";
//    [MZLServices personalizeServiceWithLocation:location filter:nil succBlock:^(NSArray *models) {
//         NSLog(@"%d", models.count);
//    } errorBlock:^(NSError *error) {
//        NSLog(@"%@", error);
//    }];
    [MZLServices locationPersonalizeServiceWithLocation:location filter:nil succBlock:^(NSArray *models) {
//        NSLog(@"%@", @(models.count));
    } errorBlock:^(NSError *error) {
//        NSLog(@"%@", error);
    }];
    
}

@end
