//
//  NSString+COAddition.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-7.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "NSString+COAddition.h"
#import "NSString+COValidation.h"
#import "COUtils.h"

@implementation COStringRegularPatternMatchResult
@end

@implementation NSString (COAddition)

- (UIColor *)co_toHexColor {
    return colorWithHexString(self);
}

- (NSString *)co_strip {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSInteger)lengthUsingUTF8Encoding {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return data.length;
}

- (NSInteger)lengthUsingCustomRule {
    NSInteger result = 0;
    for (int i = 0; i < self.length; i++) {
        NSString *character = [self substringWithRange:NSMakeRange(i, 1)];
        if ([character isAllChineseCharacters]) {
            result += 2;
        } else {
            result += 1;
        }
    }
    return result;
}

- (NSString *)co_substringBetweenLeft:(NSString *)left right:(NSString *)right {
    NSRange leftRange = [self rangeOfString:left];
    NSRange rightRange = [self rangeOfString:right options:NSBackwardsSearch];
    if (leftRange.length > 0 && rightRange.length > 0) {
        NSUInteger matchedRangeStart = leftRange.location + leftRange.length;
        NSUInteger matchedLength = rightRange.location - matchedRangeStart;
        NSRange matchedRange = NSMakeRange(matchedRangeStart, matchedLength);
        return [self substringWithRange:matchedRange];
    }
    return self;
}

- (NSArray *)co_matchWithRegularPattern:(NSString *)regularPatter {
    if (! regularPatter) {
        return nil;
    }
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularPatter options:0 error:&error];
    NSArray *matches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    NSMutableArray *result = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        COStringRegularPatternMatchResult *matchResult = [[COStringRegularPatternMatchResult alloc] init];
        matchResult.matchedRange = [match range];
        matchResult.matchedSubstring = [self substringWithRange:[match range]];
        [result addObject:matchResult];
    }
    return result;
}

- (NSString *)co_stringWithIntegerParam:(NSInteger)intergerParam {
    return [NSString stringWithFormat:self, intergerParam];
}

- (NSString *)co_stringWithIntegerParam1:(NSInteger)intergerParam1 intergerParam2:(NSInteger)intergerParam2 {
    return [NSString stringWithFormat:self, intergerParam1, intergerParam2];
}

- (CGSize)co_boundingRectWithWidth:(CGFloat)width font:(UIFont *)font {
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return rect.size;
}

- (NSInteger)co_numberOfLinesConstrainedToWidth:(CGFloat)width withFont:(UIFont *)font {
    CGSize boundingSize = [self co_boundingRectWithWidth:width font:font];
    return floorf(boundingSize.height / font.lineHeight);
}


@end
