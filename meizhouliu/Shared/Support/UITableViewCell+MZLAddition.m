//
//  UITableViewCell+MZLAddition.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-3.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UITableViewCell+MZLAddition.h"
#import "UITableViewCell+COAddition.h"

#define KEY_CELL_DELETE_IMAGE @"KEY_CELL_DELETE_IMAGE"
#define KEY_CELL_DELETE_BGIMAGE @"KEY_CELL_DELETE_BGIMAGE"
#define KEY_CELL_DELETE_BGCOLOR @"KEY_CELL_DELETE_BGCOLOR"

@implementation UITableViewCell (MZLAddition)

- (void)mzl_checkAndReplaceDeleteControl:(UITableViewCellStateMask)state {
    [self mzl_checkAndReplaceDeleteControl:state image:nil bgImage:nil bgColor:nil];
}

- (void)mzl_checkAndReplaceDeleteControl:(UITableViewCellStateMask)state image:(UIImage *)image bgImage:(UIImage *)bgImage bgColor:(UIColor *)bgColor {
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask)
    {
        if (! co_isVerAtLeast(8)) { // iOS7 及以下进行替换
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[KEY_CELL_DELETE_IMAGE] = image? image : [UIImage imageNamed:@"DeleteCell"];
            if (bgImage) {
                dict[KEY_CELL_DELETE_BGIMAGE] = bgImage;
            }
            dict[KEY_CELL_DELETE_BGCOLOR] = bgColor? bgColor : colorWithHexString(MZL_TABLEVIEWCELL_DELETE_BGCOLOR_HEX);
            [self performSelector:@selector(_mzl_checkAndReplaceDeleteControl:) withObject:dict afterDelay:0];
        }
        
    }
}

- (void)_mzl_checkAndReplaceDeleteControl:(NSDictionary *)params {
    // [self co_replaceDeleteControlWithImage:params[KEY_CELL_DELETE_IMAGE] bgImage:params[KEY_CELL_DELETE_BGIMAGE] bgColor:params[KEY_CELL_DELETE_BGCOLOR]];
}

@end
