//
//  MZLModelUser.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-7-31.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelUser.h"
#import "MZLModelAuthor.h"

@implementation MZLModelUser

- (NSString *)photoUrl {
    return self.headerImage.fileUrl;
}

- (NSString *)coverUrl {
    return self.cover.fileUrl;
}

- (BOOL)isSignedAuthor {
    return self.level == MZLModelUserTypeSignedAuthor;
}

- (NSString *)name {
    
    return self.nickName;
}

- (NSString *)phone {
    return _phone;
}

#pragma mark - restkit mapping

+ (NSMutableArray *)attrArray {
    return [[super attrArray] addArray:@[@"level", @"sex"]];
}

+ (NSMutableDictionary *)attributeDictionary {
    return [[[[[super attributeDictionary]
            fromPath:@"nickname"    toProperty:@"nickName"]
            fromPath:@"phone"       toProperty:@"phone"]
            fromPath:@"intro"       toProperty:@"introduction"]
            fromPath:@"tags_str"    toProperty:@"tags"];
    
}

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
    [mapping addRelationFromPath:@"photo" toProperty:@"headerImage" withMapping:[MZLModelImage rkObjectMapping]];
    [mapping addRelationFromPath:@"cover" toProperty:@"cover" withMapping:[MZLModelImage rkObjectMapping]];
}

- (MZLModelAuthor *)toAuthor {
    MZLModelAuthor *author = [[MZLModelAuthor alloc] init];
    author.identifier = self.identifier;
    author.name = self.nickName;
    author.photo = self.headerImage;
    author.phone = self.phone;
    return author;
}

@end
