//
//  MZLShortAcleChooseLocItemCellTableViewCell.h
//  mzl_mobile_ios
//
//  Created by race on 14/12/29.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZLModelSurroundingLocations;

@interface MZLShortArticleChooseLocItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblLocName;
@property (weak, nonatomic) IBOutlet UILabel *lblLocAddress;

@property (assign, nonatomic) BOOL isVisted;

- (void)updateOnFirstVisit;

- (void)updateContentWithLocationInfo:(MZLModelSurroundingLocations *)location;

@end
