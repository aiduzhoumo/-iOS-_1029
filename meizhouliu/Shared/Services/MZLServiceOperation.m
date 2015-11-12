//
//  MZLServiceOperation.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-12-24.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLServiceOperation.h"

@implementation MZLServiceOperation

- (BOOL)isFinished {
    return [self.internalOper isFinished];
}

- (void)cancel {
    return [self.internalOper cancel];
}

@end
