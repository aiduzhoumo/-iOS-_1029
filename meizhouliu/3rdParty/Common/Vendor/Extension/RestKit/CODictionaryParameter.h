//
//  CODictionaryParameter.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-26.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CODictionaryParameterExtension.h"

@protocol CODictionaryParameter <NSObject>

- (NSDictionary *)toDictionary;

@end
