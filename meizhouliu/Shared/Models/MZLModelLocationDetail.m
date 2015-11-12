//
//  MZLModelLocationDetail.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-22.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelLocationDetail.h"
#import "MZLModelImage.h"
#import "MZLModelTagDesp.h"

@implementation MZLModelLocationDetail

- (NSString *)coverImageUrl {
    if (self.coverImage) {
        return [super coverImageUrl];
    } else if (self.photos.count > 0) {
        MZLModelImage *firstPhoto = self.photos[0];
        return firstPhoto.fileUrl;
    }
    return nil;
}

- (NSString *)topParentLocationName {
    if (self.topParent) {
        return self.topParent.name;
    }
    return self.topParentName;
}

- (NSInteger)topParentLocationId {
    return self.topParent.identifier;
}

- (NSString *)tagDesp {
    if (self.tagDesps && self.tagDesps.count > 0) {
        NSArray *tagsWithDesp = [self.tagDesps select:^BOOL(MZLModelTagDesp *object) {
            return ! isEmptyString(object.desp);
        }];
        if (tagsWithDesp.count == 0) {
            return nil;
        }
        NSInteger index = generateRandomNumber(0, tagsWithDesp.count - 1);
        MZLModelTagDesp *tagDesp  = tagsWithDesp[index];
        return tagDesp.desp;
    }
    return nil;
}

@end
