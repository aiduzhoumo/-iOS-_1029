//
//  MZLModelShortArticle.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-15.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "MZLModelShortArticle.h"
#import "MZLPhotoItem.h"
#import "MZLModelSurroundingLocations.h"
#import "MZLModelImage.h"
#import "NSString+MZLImageURL.h"

@interface MZLModelShortArticle () {
    /** 仅用来track状态 */
    MZLModelShortArticleUp *_fakeUp;
    BOOL _isUp;
<<<<<<< HEAD
    BOOL _isAttention;
=======
>>>>>>> parent of d1afe84... Merge branch 'mzl_FJbranch'
}

@property (nonatomic, copy) NSString *photoOrder;

@end

@implementation MZLModelShortArticle

- (BOOL)arePhotosUploaded {
    for (MZLPhotoItem *photoItem in self.photos) {
        if (! [photoItem isPhotoUploaded]) {
            return NO;
        }
    }
    return YES;
}

- (NSInteger)countOfUploadedPhotos {
    NSInteger result = 0;
    for (MZLPhotoItem *photoItem in self.photos) {
        if ([photoItem isPhotoUploaded]) {
            result ++;
        }
    }
    return result;
}

- (MZLModelImage *)firstPhoto {
    id item = self.photos[0];
    if ([item isKindOfClass:[MZLPhotoItem class]]) {
        return ((MZLPhotoItem *)item).uploadedImage;
    } else if ([item isKindOfClass:[MZLModelImage class]]) {
        return self.sortedPhotos[0];
    }
    return nil;
}

- (BOOL)needsGetUpStatusForCurrentUser {
    return _fakeUp == nil;
}

- (BOOL)isUpForCurrentUser {
    return _isUp;
}

- (void)setIsUpForCurrentUser:(BOOL)isUpForCurrentUser {
    _isUp = isUpForCurrentUser;
    if (! _fakeUp) {
        _fakeUp = [[MZLModelShortArticleUp alloc] init];
    }
}

- (NSString *)publishedAtStr {
    return dateToString(@"yyyy/MM/dd", [NSDate dateWithTimeIntervalSince1970:self.publishedAt]);
}

- (NSArray *)sortedPhotos {
    if (! isEmptyString(self.photoOrder)) {
        NSMutableArray *sorted = [NSMutableArray array];
        NSArray *sortedPhotoIds = [self.photoOrder split:@","];
        for (NSString *photoId in sortedPhotoIds) {
            MZLModelImage *image = [self.photos find:^BOOL(MZLModelImage *modelImage) {
                return (modelImage.identifier == [photoId integerValue]);
            }];
            if (image) {
                [sorted addObject:image];
            }
        }
        return sorted;
    }
    return self.photos;
}

- (NSArray *)sortedPhotosInViewMode {
    // 取scale的模板
    NSArray *photos = self.sortedPhotos;
    NSMutableArray *result = co_emptyMutableArray();
    for (MZLModelImage *photo in photos) {
        [result addObject:[photo.fileUrl imageUrl_Scaled]];
    }
    return [NSArray arrayWithArray:result];
}

- (NSInteger)goodsCount {
    return self.location.productsCount;
}

#pragma mark - override

- (NSMutableDictionary *)_toDictionary {
    NSMutableDictionary *dict = [super _toDictionary];
    
    [dict setKey:@"short_article[destination_id]" intValue:self.location.identifier];
    if (!isEmptyString(self.content)) {
        [dict setKey:@"short_article[content]" strValue:self.content];
    }
    
    [dict setKey:@"short_article[tag_list]" strValue:self.tags];
    if (self.consumption > 0) {
        [dict setKey:@"short_article[consumption]" intValue:self.consumption];
    }
    
    NSMutableArray *photoIds = [NSMutableArray array];
    [self.photos each:^(id object) {
        [photoIds addObject:@(((MZLPhotoItem *)object).uploadedImage.identifier)];
    }];
    [dict setKey:@"short_article[photo_order]" strValue:[photoIds join:@","]];
    
    return dict;

}

+ (NSMutableArray *)attrArray {
    return [[super attrArray] addArray:@[@"content", @"consumption"]];
}

+ (NSMutableDictionary *)attributeDictionary {
    NSMutableDictionary *dict = [super attributeDictionary];
    [dict fromPath:@"tags_str" toProperty:@"tags"];
    [dict fromPath:@"comments_count" toProperty:@"commentsCount"];
    [dict fromPath:@"ups_count" toProperty:@"upsCount"];
    [dict fromPath:@"published_at" toProperty:@"publishedAt"];
    [dict fromPath:@"photo_order" toProperty:@"photoOrder"];
    return dict;
}

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
    [mapping addRelationFromPath:@"user" toProperty:@"author" withMapping:[MZLModelUser rkObjectMapping]];
    [mapping addRelationFromPath:@"destination" toProperty:@"location" withMapping:[MZLModelSurroundingLocations rkObjectMapping]];
    [mapping addRelationFromPath:@"photos" toProperty:@"photos" withMapping:[MZLModelImage rkObjectMapping]];
}

@end
