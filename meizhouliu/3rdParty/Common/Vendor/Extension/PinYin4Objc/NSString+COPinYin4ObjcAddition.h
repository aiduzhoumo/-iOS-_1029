//
//  NSString+COPinYin4ObjcAddition.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-19.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CO_PINYIN_NO_SEPARATOR @""
#define CO_PINYIN_SPACE_SEPARATOR @" "

@interface NSString (COPinYin4ObjcAddition)

- (NSString *)co_toPinYin;
- (NSString *)co_toPinYinWithSeparator:(NSString *)separator;

@end
