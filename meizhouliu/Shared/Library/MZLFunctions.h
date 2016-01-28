//
//  MZLFunctions.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-8.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class MZLModelLocationBase, MZLModelLocationDetail;

NSString *formatTags(NSString *tags, NSString *separator);
NSArray *generateTags(NSString *tags);

#pragma mark - cities and locations

NSArray *allCities();
NSArray *allLocations();
//void refreshSystemLocations();
NSString *cityFromGPSLocation(NSString *gpsLocation);
NSDictionary *cityPinyinDictionary();

#pragma mark - location related
BOOL isCoordinateValid(CLLocationCoordinate2D point);
BOOL isLocationCoordinateValid(MZLModelLocationDetail *location);
/** whether string has any character in charaters */
BOOL hasAnyCharacter(NSString *string, NSString *characters);
MKCoordinateSpan coordinateSpanFromLocation(MZLModelLocationBase *location);

MKCoordinateSpan coordinateSpanAmongLocations(MZLModelLocationBase *centerLocation, NSArray *locations, CGFloat scale, BOOL isDisplayAllLocations);
MKCoordinateSpan coordinateSpanAmongPoints(CLLocationCoordinate2D curPoint, NSArray *points, CGFloat scale, BOOL isDisplayAllPoints);

#pragma mark - date related functions
NSDate* dateFromString(NSString *str);
NSDate* yesterday();
NSURL *webUrl(NSString *url);
NSURL *webDuZhouMoUrl(NSString *url);

#pragma mark - identify bundle identifier;
BOOL isMZLProdApp();
BOOL isMZLTestApp();

#pragma mark - application badges
NSInteger appBadgeCount();
void updateAppBadgeWithUnreadNotiCount();
//void updateAppBadge(NSInteger badgeCount);

NSArray *imagesOfCrowd();

NSArray *imagesOfFeature();