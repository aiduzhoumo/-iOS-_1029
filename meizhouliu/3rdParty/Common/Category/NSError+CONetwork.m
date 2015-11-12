//
//  NSError+CONetwork.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-2.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "NSError+CONetwork.h"
#import "NSObject+COAssociation.h"

#define KEY_NSERROR_CONETWORK_RESPONSE_CODE @"KEY_NSERROR_CONETWORK_RESPONSE_CODE"

@implementation NSError (CONetwork)

- (void)co_setResponseStatusCode:(NSInteger)statusCode {
    [self setProperty:KEY_NSERROR_CONETWORK_RESPONSE_CODE value:@(statusCode)];
}

- (NSInteger)co_responseStatusCode {
    NSNumber *result = [self getProperty:KEY_NSERROR_CONETWORK_RESPONSE_CODE];
    if (result) {
        return [result integerValue];
    }
    return -1;
}

@end
