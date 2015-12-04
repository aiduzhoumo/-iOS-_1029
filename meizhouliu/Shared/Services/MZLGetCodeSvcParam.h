//
//  MZLGetCodeSvcParam.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 15/11/25.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZLGetCodeSvcParam : NSObject

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *type;

//+ (MZLDescendantsParam *)descendantsParamsFromDescendants:(NSArray *)descendantIds;

- (NSMutableDictionary *)toDictionary;


@end
