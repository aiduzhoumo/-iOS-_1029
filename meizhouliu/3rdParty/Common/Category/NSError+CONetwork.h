//
//  NSError+CONetwork.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-2.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (CONetwork)

- (void)co_setResponseStatusCode:(NSInteger)statusCode;
- (NSInteger)co_responseStatusCode;

@end
