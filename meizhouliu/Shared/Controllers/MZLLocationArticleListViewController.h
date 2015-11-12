//
//  MZLLocationArticleListViewController.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-6-26.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLArticleListViewController.h"
#import "ParallaxHeaderView.h"
@class MZLLocationDetailViewController;

@interface MZLLocationArticleListViewController : MZLArticleListViewController<ParallaxHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (nonatomic, strong) MZLModelLocationBase *locationParam;
@property (nonatomic, strong) MZLLocationDetailViewController *ownerVc;
@property (nonatomic, strong) MZLModelUserLocationPref *locUserPref;

- (void)toggleFavoredImage:(MZLModelUserLocationPref *)userLocPref;
@end
