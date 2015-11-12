//
//  CODictionaryParameterExtension.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-26.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CODictionaryParameterExtension : NSObject

@end

@interface NSMutableDictionary (CODictionaryParameterExtension)

- (NSMutableDictionary *)setKey:(NSString *)key intValue:(NSInteger)intValue;
- (NSMutableDictionary *)setKey:(NSString *)key strValue:(NSString *)strValue;

@end
