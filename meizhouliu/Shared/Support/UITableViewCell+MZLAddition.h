//
//  UITableViewCell+MZLAddition.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-3.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MZL_TABLEVIEWCELL_DELETE_BGCOLOR_HEX @"#ff243e"

@interface UITableViewCell (MZLAddition)

- (void)mzl_checkAndReplaceDeleteControl:(UITableViewCellStateMask)state;
- (void)mzl_checkAndReplaceDeleteControl:(UITableViewCellStateMask)state image:(UIImage *)image bgImage:(UIImage *)bgImage bgColor:(UIColor *)bgColor;

@end
