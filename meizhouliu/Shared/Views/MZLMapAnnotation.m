//
//  MZLMapAnnotation.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-4-24.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLMapAnnotation.h"

@implementation MZLMapAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

-(id) initWithLocation:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle subTitle:(NSString *)paramSubTitle
{
    self = [super init];
    if (self)
    {
        coordinate = paramCoordinates;
        title = paramTitle;
        subtitle = paramSubTitle;
    }
    return self;
}
@end
