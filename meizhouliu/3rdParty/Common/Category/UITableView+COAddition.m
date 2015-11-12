//
//  UITableView+COAddition.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-21.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "UITableView+COAddition.h"

@implementation UITableView (COAddition)

- (id)co_dequeueReusableCellWithClass:(NSString *)classNameAsID {
    id result = [self dequeueReusableCellWithIdentifier:classNameAsID];
    if (! result) {
        [self registerClass:NSClassFromString(classNameAsID) forCellReuseIdentifier:classNameAsID];
        result = [self dequeueReusableCellWithIdentifier:classNameAsID];
    }
    return result;
}

- (id)co_dequeueReusableCellWithClassFromClass:(Class)clazz {
    return [self co_dequeueReusableCellWithClass:NSStringFromClass(clazz)];
}

- (id)co_dequeueReusableCellWithNib:(NSString *)classNameAsID {
    id result = [self dequeueReusableCellWithIdentifier:classNameAsID];
    if (! result) {
        [self registerNib:[UINib nibWithNibName:classNameAsID bundle:nil] forCellReuseIdentifier:classNameAsID];
        result = [self dequeueReusableCellWithIdentifier:classNameAsID];
    }
    return result;
}

- (id)co_dequeueReusableCellWithNibFromClass:(Class)clazz {
    return [self co_dequeueReusableCellWithNib:NSStringFromClass(clazz)];
}

@end
