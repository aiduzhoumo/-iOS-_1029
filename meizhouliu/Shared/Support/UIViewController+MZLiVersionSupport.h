//
//  UIViewController+MZLiVersionSupport.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-11-25.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iVersion.h"

@interface UIViewController (MZLiVersionSupport)

- (void)mzl_checkVersionIfNecessary;

/** 一般在viewWillDisappear时调用 */
- (void)mzl_resetVersionDelegate;

@end
