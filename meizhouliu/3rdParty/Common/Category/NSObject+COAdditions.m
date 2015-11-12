//
//  NSObject+COAdditions.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-28.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "NSObject+COAdditions.h"
#import "NSInvocation+COAdditions.h"

@implementation NSObject (COAdditions)

- (id)performSelector:(SEL)aSelector withParams:(NSArray *)params {
    id result = nil;
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    if (signature) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:aSelector];
        NSUInteger methodParamLen = signature.numberOfArguments;
        // 如果该方法存在参数（len >2, 0为方法拥者，1为方法名)
        if (methodParamLen > 2) {
            for (int i = 2; i < methodParamLen; i++) {
                id param = params[i - 2];
                [invocation setArgument:&param atIndex:i];
            }
        }
        [invocation invoke];
        if (signature.methodReturnLength > 0) {
            result = [invocation objectReturnValue];
        }
    }
    return result;
}

- (id)performSelector:(SEL)aSelector withMultiObjects:(id)object,... {
    //返回值
    id anObject = nil;
    @autoreleasepool {
        //获取方法信息
        NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
        //判断方法信息是否存在
        if(signature){
            //创建方法调用方法
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            //设置方法调用类
            [invocation setTarget:self];
            //设置方法
            [invocation setSelector:aSelector];
            //获取方法参数长度
            NSUInteger len = signature.numberOfArguments;
            //如果方法有参数（len > 2, 0为方法拥者，1为方法名)
            if(len > 2){
                //用于获取参数的值的变量
                id value = object;
                //参数列表变量
                va_list arguments;
                //通知参数列表开始获取参数
                va_start(arguments, object);
                //循环添加方法相应的参数
                for(int i = 2; i < len; i++){
                    //添加参数
                    [invocation setArgument:&value atIndex:i];
                    //获取新的参数
                    if(value != nil){
                        value = va_arg(arguments, id);
                    }
                }
                //通知参数列表结束参数获取
                va_end(arguments);
            }
            //执行方法
            [invocation invoke];
            //判断方法的返回值
            if(signature.methodReturnLength == 1){
                anObject = [invocation objectReturnValue];
            }
        }
    }
    return anObject;
}

@end
