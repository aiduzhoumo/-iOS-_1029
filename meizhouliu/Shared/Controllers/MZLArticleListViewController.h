//
//  MZLArticleListViewController.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-8.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MZLTableViewControllerWithFilter.h"
#import "MZLArticleListSvcParam.h"

#define MZL_ARTICLE_LIST_VC_TV_MARGIN 15.0

@class MZLModelLocationBase, MZLArticleListSvcParam;

@interface MZLArticleListViewController : MZLTableViewControllerWithFilter {
@protected
    BOOL _ignoreScrollEvent;
}

@property (weak, nonatomic) IBOutlet UITableView *tvArticleList;

/** load articles with location(city) */
//- (void)loadArticlesWithLocation:(NSString *)location;

@end

@interface MZLArticleListViewController (ProtectedForOverride)

- (void)initControls;
//- (void)loadArticles;

- (void)_loadMoreArticlesWithoutFilters:(MZLArticleListSvcParam *)param;


@end

