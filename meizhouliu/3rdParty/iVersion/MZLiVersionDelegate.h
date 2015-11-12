//
//  MZLiVersionDelegate.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-6-17.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iVersion.h"

@interface MZLiVersionDelegate : NSObject<iVersionDelegate>

+ (MZLiVersionDelegate *)sharedInstance;

@end
