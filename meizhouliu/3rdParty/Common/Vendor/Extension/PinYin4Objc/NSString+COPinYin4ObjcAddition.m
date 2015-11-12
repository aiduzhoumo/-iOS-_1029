//
//  NSString+COPinYin4ObjcAddition.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-19.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "NSString+COPinYin4ObjcAddition.h"
#import "PinYin4Objc.h"

@implementation NSString (COPinYin4ObjcAddition)

- (NSString *)co_toPinYin {
    return [self co_toPinYinWithSeparator:CO_PINYIN_NO_SEPARATOR];
}

- (NSString *)co_toPinYinWithSeparator:(NSString *)separator {
    static HanyuPinyinOutputFormat *outputFormat;
    if (! outputFormat) {
        outputFormat = [[HanyuPinyinOutputFormat alloc] init];
        [outputFormat setToneType:ToneTypeWithoutTone];
        [outputFormat setVCharType:VCharTypeWithV];
        [outputFormat setCaseType:CaseTypeLowercase];
    }
    return [PinyinHelper toHanyuPinyinStringWithNSString:self withHanyuPinyinOutputFormat:outputFormat withNSString:separator];
}

@end
