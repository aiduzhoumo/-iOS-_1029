//
//  MZLShortArticleChooseLocVC.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-12-29.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface MZLShortArticleChooseLocVC : MZLTableViewController<AMapSearchDelegate, CLLocationManagerDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfLocation;

@end
