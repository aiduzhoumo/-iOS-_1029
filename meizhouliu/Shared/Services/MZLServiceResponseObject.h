//
//  MZLServiceResponseObject.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-28.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+CORestKitMapping.h"

@class MZLMessagesResponse;

@interface MZLServiceResponseObject : NSObject

@property (nonatomic, assign) NSInteger error;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSArray *messages;

@property (nonatomic, readonly) NSString *errorMessage;

@end
