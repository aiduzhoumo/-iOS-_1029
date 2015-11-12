//
//  MZLMapAnnotation.h
//  mzl_mobile_ios
//
//  Created by alfred on 14-4-24.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MZLMapAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *displayName;

- (id)initWithLocation:(CLLocationCoordinate2D)paramCoordinates
                 title:(NSString *) paramTitle
              subTitle:(NSString *)paramSubTitle;


@end
