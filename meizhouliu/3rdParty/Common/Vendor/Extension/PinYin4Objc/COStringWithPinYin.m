//
//  COStringWithPinYin.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-20.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "COStringWithPinYin.h"
#import "NSString+COPinYin4ObjcAddition.h"

@implementation COStringWithPinYin

+ (instancetype)instanceFromString:(NSString *)str {
    COStringWithPinYin *pinyinObj = [[COStringWithPinYin alloc] init];
    pinyinObj.str = str;
    NSString *pinyinWithSpace = [str co_toPinYinWithSeparator:CO_PINYIN_SPACE_SEPARATOR];
    NSArray *pinyinArray = [pinyinWithSpace split:CO_PINYIN_SPACE_SEPARATOR];
    NSMutableString *pinyin = [NSMutableString string];
    NSMutableString *capitals = [NSMutableString string];
    for (NSString *singlePinyin in pinyinArray) {
        [pinyin appendString:singlePinyin];
        [capitals appendString:[singlePinyin substringToIndex:1]];
    }
    pinyinObj.pinyin = pinyin;
    pinyinObj.pinyinCapital = capitals;
    return pinyinObj;
}

#define KEY_PINYIN_STR @"str"
#define KEY_PINYIN_PINYIN @"py"
#define KEY_PINYIN_CAPITALS @"cap"

- (NSDictionary *)toDictionary {
    return @ {
        KEY_PINYIN_STR : self.str,
        KEY_PINYIN_PINYIN : self.pinyin,
        KEY_PINYIN_CAPITALS : self.pinyinCapital
    };
}

+ (instancetype)instanceFromDictionary:(NSDictionary *)dict {
    COStringWithPinYin *pinyinObj = [[COStringWithPinYin alloc] init];
    pinyinObj.str = dict[KEY_PINYIN_STR];
    pinyinObj.pinyin = dict[KEY_PINYIN_PINYIN];
    pinyinObj.pinyinCapital = dict[KEY_PINYIN_CAPITALS];
    return pinyinObj;
}


@end
