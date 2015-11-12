//
//  NSInvocation+COAdditions.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-12.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "NSInvocation+COAdditions.h"

@implementation NSInvocation (COAdditions)

- (id)objectReturnValue {
    __unsafe_unretained id result;
    [self getReturnValue:&result];
    return result;
    
//    // the following is also correct
//    void *pointer;
//    [self getReturnValue:&pointer];
//    
//    return (__bridge id)pointer; //Correct, ARC will retain pointer after assignment
}

@end
