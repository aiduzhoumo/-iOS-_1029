//
//  MZLLocationDelegate.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-6-25.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchAPI.h>


@interface MZLLocationDelegate : NSObject <AMapSearchDelegate, CLLocationManagerDelegate>

+ (MZLLocationDelegate *)sharedInstance;

//- (void)reset;
//@property (nonatomic, assign) BOOL isLocationUpdated;

@end
