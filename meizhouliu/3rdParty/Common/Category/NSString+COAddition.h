//
//  NSString+COAddition.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-7.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CO_CHAR_ZERO_WIDTH_SPACE @"\u200B"

@interface COStringRegularPatternMatchResult : NSObject

@property (nonatomic, copy) NSString *matchedSubstring;
@property (nonatomic, assign) NSRange matchedRange;

@end

@interface NSString (COAddition)

/** 将自身转化为Color, 前置条件为自身是十六进制的颜色代码如 0x999999/#999999/999999 */
@property (nonatomic, readonly) UIColor *co_toHexColor;

- (NSString *)co_strip;

- (NSInteger)lengthUsingUTF8Encoding;
/** 自定义字符长度规则：中文算2个字符，其它算1个字符 */
- (NSInteger)lengthUsingCustomRule;

- (NSString *)co_substringBetweenLeft:(NSString *)left right:(NSString *)right;

/** 返回的是符合规则的COStringRegularPatternMatchResult对象 */
- (NSArray *)co_matchWithRegularPattern:(NSString *)regularPatter;

- (NSString *)co_stringWithIntegerParam:(NSInteger)intergerParam;
- (NSString *)co_stringWithIntegerParam1:(NSInteger)intergerParam1 intergerParam2:(NSInteger)intergerParam2;
- (NSString *)co_stringWithNSStringParam1:(NSString *)param1 nsstringParam2:(NSString *)param2;
- (NSString *)co_stringWithNSStringParam1:(NSString *)param1 nsstringParam2:(NSString *)param2 nsstringParam3:(NSString *)param3;

- (CGSize)co_boundingRectWithWidth:(CGFloat)width font:(UIFont *)font;
- (NSInteger)co_numberOfLinesConstrainedToWidth:(CGFloat)width withFont:(UIFont *)font;

@end
