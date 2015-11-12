//
//  UITableView+MZLHeaderFooterView.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-28.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAG_REFRESHVIEW_ACTIVITYINDICATOR 100
#define TAG_REFRESHVIEW_LABEL 101

//#define TAG_MASTERDETAILLABEL_MASTERLABEL 200
//#define TAG_MASTERDETAILLABEL_DETAILLABEL 201


@interface UITableView (MZLHeaderFooterView)

- (UIView *)refreshView;
- (UIView *)refreshView:(NSString *)text;
//- (void)showFooterActivityIndicator;
//- (void)hideFooterActivityIndicator;

- (UIView *)labelsView:(NSArray *)textsToDisplay;

@end
