//
//  MZLServiceResponseObject.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-28.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLServiceResponseObject.h"
#import "MZLServiceResponseDetail.h"

@implementation MZLServiceResponseObject

- (NSString *)errorMessage {
    if (self.message) {
        return self.message;
    } else if (self.messages) {
        NSMutableString *str = [NSMutableString string];
        for (MZLServiceResponseDetail *detail in self.messages) {
//            [str appendString:[detail.detail componentsJoinedByString:@","]];
            return detail.detail.count > 0 ? detail.detail[0] : @"";
        }
        return str;
    }
    return @"";
}

#pragma mark - restkit mapping

+ (NSMutableArray *)attrArray {
    return [[super attrArray] addArray:@[@"error", @"message"]];
}

+ (void)addRelationMapping:(RKObjectMapping *)mapping {
    [mapping addRelationWithPath:@"messages" andMapping:[MZLServiceResponseDetail rkObjectMapping]];
}

@end
