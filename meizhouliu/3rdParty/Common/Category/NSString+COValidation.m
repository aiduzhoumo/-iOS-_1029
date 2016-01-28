//
//  NSString+COValidation.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-7.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "NSString+COValidation.h"

@implementation NSString (COValidation)

- (BOOL)isValidEmail {
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self isValidViaRegExp:emailCheck];
}

- (BOOL)isAllChineseCharacters {
    NSString *chineseCheck = @"^[\u4E00-\u9FA5]*$";
    return [self isValidViaRegExp:chineseCheck];
}

- (BOOL)isAllEnglishLetters {
    NSString *check = @"[A-Za-z]+";
    return [self isValidViaRegExp:check];
}

- (BOOL)co_isAllDigits {
    NSString *check = @"[0-9]+";
    return [self isValidViaRegExp:check];
}

- (BOOL)isValidPhone {
    NSString * check = @"^1(?:3[0-9]|4[57]|5[0-9]|8[0-9]|7[0678])\\d{8}$";
    return [self isValidViaRegExp:check];
}

- (BOOL)isValidViaRegExp:(NSString *)regExp {
    NSPredicate *regTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", regExp];
    return [regTest evaluateWithObject:self];
}




@end
