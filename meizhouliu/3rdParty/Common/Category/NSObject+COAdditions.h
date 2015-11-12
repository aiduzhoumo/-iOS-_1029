//
//  NSObject+COAdditions.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-28.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (COAdditions)

- (id)performSelector:(SEL)aSelector withParams:(NSArray *)params;
//执行多个参数的方法
- (id)performSelector:(SEL)aSelector withMultiObjects:(id)object,...;

@end
