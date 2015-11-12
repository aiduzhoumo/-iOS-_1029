//
//  UITableView+COAddition.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-1-21.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (COAddition)

- (id)co_dequeueReusableCellWithClass:(NSString *)classNameAsID;
- (id)co_dequeueReusableCellWithClassFromClass:(Class)clazz;
/** Your nib should have the same name as the class name */
- (id)co_dequeueReusableCellWithNib:(NSString *)classNameAsID;
- (id)co_dequeueReusableCellWithNibFromClass:(Class)clazz;


@end
