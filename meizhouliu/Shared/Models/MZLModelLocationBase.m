//
//  MZLModelLocationBase.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-25.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelLocationBase.h"
#import "MZLModelImage.h"
#import "MZLModelLocationExt.h"

@implementation MZLModelLocationBase

- (NSString *)coverImageUrl {
    return self.coverImage.fileUrl;
}

- (NSString *)address {
    return self.locationExt.address;
}

- (NSString *)introduction {
    return self.locationExt.introduction;
}

#pragma mark - override

+ (NSMutableArray *)attrArray {
    return [[super attrArray] addArray:@[@"longitude", @"latitude", @"name"]];
}

+ (NSMutableDictionary *)attributeDictionary {
    NSMutableDictionary *dict = [super attributeDictionary];
    [dict fromPath:@"short_articles_count" toProperty:@"shortArticleCount"];
    [dict fromPath:@"is_viewpoint" toProperty:@"isViewPoint"];
    [dict fromPath:@"tags_str" toProperty:@"tagsStr"];
    return dict;
}

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
    [mapping addRelationFromPath:@"cover" toProperty:@"coverImage" withMapping:[MZLModelImage rkObjectMapping]];
    [mapping addRelationFromPath:@"destination_detail" toProperty:@"locationExt" withMapping:[MZLModelLocationExt rkObjectMapping]];
}

@end
