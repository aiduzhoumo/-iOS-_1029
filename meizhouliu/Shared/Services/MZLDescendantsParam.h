//
//  MZLDescendantsParam.h
//  mzl_mobile_ios
//
//  Created by race on 14/12/22.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZLDescendantsParam : NSObject

@property (nonatomic, copy) NSString *descendantIds;

+ (MZLDescendantsParam *)descendantsParamsFromDescendants:(NSArray *)descendantIds;

- (NSMutableDictionary *)toDictionary;

@end
