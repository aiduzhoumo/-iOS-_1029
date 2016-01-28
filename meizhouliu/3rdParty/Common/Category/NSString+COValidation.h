//
//  NSString+COValidation.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-7.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (COValidation)

- (BOOL)isValidEmail;

- (BOOL)isAllChineseCharacters;
- (BOOL)isAllEnglishLetters;
- (BOOL)isValidPhone;
- (BOOL)co_isAllDigits;

- (BOOL)isValidViaRegExp:(NSString *)regExp;

@end
