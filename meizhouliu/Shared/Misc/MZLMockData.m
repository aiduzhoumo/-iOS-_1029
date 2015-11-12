//
//  MZLMockData.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-2-10.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLMockData.h"
#import "MZLModelArticle.h"

@implementation MZLMockData

#pragma mark - short article related

+ (MZLModelShortArticleComment *)mockShortArticleComment {
    MZLModelShortArticleComment *comment = [[MZLModelShortArticleComment alloc] init];
    MZLModelUser *user = [[MZLModelUser alloc] init];
    user.nickName = @"Test很长很长的Test很长很长的Test很长很长的Test很长很长的Test很长很长的Test很长很长的";
    MZLModelImage *image = [[MZLModelImage alloc] init];
    image.fileUrl = @"http://meizhouliu-photo.b0.upaiyun.com/uploads/photo/file/29364/image.jpg";
    comment.user = user;
    comment.content = @"TestTest很长很长的Test很长很长的Test很长很长的Test很长很长的Test很长很长的Test很长很长的";
    comment.publishedAt = [[NSDate date] timeIntervalSince1970];
    comment.identifier = 1;
    return comment;
}

+ (MZLModelShortArticle *)mockShortArticle {
    MZLModelShortArticle *shortArticle = [[MZLModelShortArticle alloc] init];
    shortArticle.content = @"现代化的大都市，外滩的外景值得一看。商业发达，交通便利。美食方面";
    
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i <= 9; i++) {
        MZLModelImage *image = [[MZLModelImage alloc] init];
        image.fileUrl = @"http://meizhouliu-photo.b0.upaiyun.com/uploads/photo/file/5514/1353294149444_U7116P704DT20120913114942.jpg";
        [images addObject:image];
    }
    shortArticle.photos = images;
    
    shortArticle.tags = @"情侣 很好玩 这是一个美丽的地方";
    
    double date = [[NSDate date] timeIntervalSince1970];
    shortArticle.publishedAt = date;
    
    shortArticle.consumption = 1000;
    
    MZLModelUser *user = [[MZLModelUser alloc] init];
    user.nickName = @"我是MT1111111111";
    MZLModelImage *image = [[MZLModelImage alloc] init];
    image.fileUrl = @"http://meizhouliu-photo.b0.upaiyun.com/uploads/photo/file/29364/image.jpg";
    shortArticle.author = user;
    MZLModelSurroundingLocations *location = [[MZLModelSurroundingLocations alloc] init];
    location.locationName = @"杭州西湖";
    MZLModelLocationExt *locExt = [[MZLModelLocationExt alloc] init];
    locExt.address = @"这是一个很长的地址";
    location.locationExt = locExt;
    shortArticle.location = location;
    return shortArticle;
}

#pragma mark - image

+ (NSString *)mockImageUrl {
    NSInteger base = 68400;
    NSInteger photoId = base + generateRandomNumber(1, 32);
    NSString *photoUrl = [NSString stringWithFormat:@"http://meizhouliu-photo.b0.upaiyun.com/uploads/photo/file/%@/image.jpg", @(photoId)];
    return photoUrl;
}

#pragma mark - notification related

+ (void)mockShortArticleNotificationWithID:(NSInteger)identifier {
    NSDictionary *shortArticleDict = @{@"id" : INT_TO_STR(identifier)};
    NSDictionary *dict = @{@"short_article" : shortArticleDict};
    [MZLSharedData setApnsInfo:dict];
}

+ (void)mockArticleNotificationWithID:(NSInteger)identifier {
    NSDictionary *articleDict = @{@"id" : INT_TO_STR(identifier)};
    NSDictionary *dict = @{@"article" : articleDict};
    [MZLSharedData setApnsInfo:dict];
}

+ (void)mockLocationNotificationWithID:(NSInteger)identifier {
    NSDictionary *locationDict = @{@"id" : INT_TO_STR(identifier)};
    NSDictionary *dict = @{@"destination" : locationDict};
    [MZLSharedData setApnsInfo:dict];
}

+ (void)mockNoticeNotificationWithID:(NSInteger)identifier {
    NSDictionary *noticeDict = @{@"id" : INT_TO_STR(identifier)};
    NSDictionary *dict = @{@"notice" : noticeDict};
    [MZLSharedData setApnsInfo:dict];
}

@end
