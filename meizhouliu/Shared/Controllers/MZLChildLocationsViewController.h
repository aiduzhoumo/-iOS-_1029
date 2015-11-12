//
//  MZLChildLocationsViewController.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-28.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLTableViewControllerWithFilter.h"

@class MZLModelLocationBase;

@interface MZLChildLocationsViewController : MZLTableViewControllerWithFilter

@property (weak, nonatomic) IBOutlet UILabel *navigationTitle;
@property (weak, nonatomic) IBOutlet UITableView *tvChildLocations;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scMyTop;
@property (weak, nonatomic) IBOutlet UIView *vwTop;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vwCategoryBarBgTop;
//@property (weak, nonatomic) IBOutlet UIView *vwCategoryBarBg;
//@property (weak, nonatomic) IBOutlet UIButton *categoryCatering;
//@property (weak, nonatomic) IBOutlet UIButton *categoryViewSpot;
//@property (weak, nonatomic) IBOutlet UIButton *categoryAccommodation;
//@property (weak, nonatomic) IBOutlet UIButton *categoryOthers;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scMy;

@property (nonatomic, strong) MZLModelLocationBase *locationParam;

//- (IBAction)clickCategoryCatering:(id)sender;
//- (IBAction)clickCategoryViewSpot:(id)sender;
//- (IBAction)clickcategoryAccommodation:(id)sender;
//- (IBAction)clickcategoryOthers:(id)sender;

@end
