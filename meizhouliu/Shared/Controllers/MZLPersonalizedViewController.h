//
//  MZLPersonalizedViewController.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-11-25.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLTableViewControllerWithFilter.h"

@class MZLPersonalizedItemCell;

@interface MZLPersonalizedViewController : MZLTableViewControllerWithFilter

@property (weak, nonatomic) IBOutlet UITableView *tvPersonalized;
@property (nonatomic, weak) IBOutlet UIView *vwTop;

- (void)toArticleDetail:(MZLModelArticle *)article anchorLocation:(MZLModelLocationBase *)location;
//- (void)toLocationDetail:(MZLModelLocationBase *)location;
//- (void)toLocationDetailArticles:(MZLModelLocationBase *)location;
//- (void)toLocationDetailLocations:(MZLModelLocationBase *)location;

@end
